//
//  AnimeCharacterDetailViewController.swift
//  Animori
//
//  Created by 이빈 on 4/9/25.
//

import UIKit
import RxSwift
import ReactorKit

final class AnimeCharacterDetailViewController: BaseViewController<AnimeCharacterDetailView> {
    
    var disposeBag = DisposeBag()
    
    init(reactor: AnimeCharacterDetailViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
}

extension AnimeCharacterDetailViewController: View {
    
    func bind(reactor: AnimeCharacterDetailViewModel) {
        reactor.action.onNext(.loadInfo)
        
        // 로딩 인디케이터
        reactor.pulse(\.$isLoading)
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isLoading in
                if isLoading {
                    Loading.shared.showLoading(in: owner.mainView)
                } else {
                    Loading.shared.hideLoading(from: owner.mainView)
                }
            }
            .disposed(by: disposeBag)
        
        // 캐릭터 사진
        reactor.state
            .map { $0.characterPictures }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, images in
                owner.mainView.characterImages = images
                owner.mainView.imagePagerView.reloadData()
            }
            .disposed(by: disposeBag)
        
        // 캐릭터 정보
        reactor.state
            .map { $0.characterInfo }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, info in
                owner.navigationItem.title = info.name
                owner.mainView.configureData(data: info)
            }
            .disposed(by: disposeBag)
        
        
        // 캐릭터 성우 정보
        reactor.state
            .map { $0.characterVoiceActors }
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.voiceActorCollectionView.rx.items(cellIdentifier: CharacterCell.identifier, cellType: CharacterCell.self)) { (row, element, cell) in
                cell.configureVoiceActor(element)
            }
            .disposed(by: disposeBag)
        
        // 에러
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                let alert = DIContainer.shared.makeAlert(retryAction: {
                    owner.reactor?.action.onNext(.loadInfo)
                })
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}
