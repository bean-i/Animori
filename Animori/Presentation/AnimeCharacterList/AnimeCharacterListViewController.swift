//
//  AnimeCharacterListViewController.swift
//  Animori
//
//  Created by 이빈 on 4/10/25.
//

import UIKit
import RxSwift
import ReactorKit

final class AnimeCharacterListViewController: BaseViewController<AnimeCharacterListView> {
    
    var disposeBag = DisposeBag()
    
    init(reactor: AnimeCharacterListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
}

extension AnimeCharacterListViewController: View {
    
    func bind(reactor: AnimeCharacterListViewModel) {
        
        reactor.action.onNext(.loadCharacters)
        
        // 로딩뷰
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isLoading in
                if isLoading {
                    Loading.shared.showLoading(in: owner.mainView)
                } else {
                    Loading.shared.hideLoading(from: owner.mainView)
                }
            }
            .disposed(by: disposeBag)
        
        // 모드에 따라 분기처리
        switch reactor.mode {
        case .anime:
            reactor.state
                .map { $0.animeCharacters }
                .bind(to: mainView.characterListCollectionView.rx.items(cellIdentifier: CharacterInfoCell.identifier, cellType: CharacterInfoCell.self)) { (row, element, cell) in
                    cell.configureAnimeData(with: element)
                }
                .disposed(by: disposeBag)
            
        case .top:
            reactor.state
                .map { $0.topCharacters }
                .bind(to: mainView.characterListCollectionView.rx.items(cellIdentifier: CharacterInfoCell.identifier, cellType: CharacterInfoCell.self)) { (row, element, cell) in
                    cell.configureData(with: element)
                }
                .disposed(by: disposeBag)
        }
        
        // 셀 탭
        switch reactor.mode {
        case .anime:
            mainView.characterListCollectionView.rx.modelSelected((any AnimeCharacterProtocol).self)
                .bind(with: self) { owner, character in
                    let vc = DIContainer.shared.makeCharacterDetailVC(id: character.id)
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
                .disposed(by: disposeBag)
            
        case .top:
            mainView.characterListCollectionView.rx.modelSelected(TopCharacterProtocol.self)
                .bind(with: self) { owner, character in
                    let vc = DIContainer.shared.makeCharacterDetailVC(id: character.id)
                    owner.navigationController?.pushViewController(vc, animated: true)
                }
                .disposed(by: disposeBag)
        }
        
        // 에러 처리
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                let alert = DIContainer.shared.makeAlert(retryAction: {
                    owner.reactor?.action.onNext(.loadCharacters)
                })
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
