//
//  AnimeListViewController.swift
//  Animori
//
//  Created by 이빈 on 4/4/25.
//

import UIKit
import RxSwift
import ReactorKit

final class AnimeListViewController: BaseViewController<AnimeListView> {
    
    var disposeBag = DisposeBag()
    
    init(reactor: AnimeListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
}

extension AnimeListViewController: View {
    
    func bind(reactor: AnimeListViewModel) {
        
        // 타이틀
        reactor.state
            .map { $0.title }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        // 정렬버튼 나타내기
        reactor.pulse(\.$sort)
            .bind(to: mainView.sortButtonCollectionView.rx.items(cellIdentifier: SortButtonCell.identifier, cellType: SortButtonCell.self)) { (row, element, cell) in
                cell.configureData(title: element.displayName)
            }
            .disposed(by: disposeBag)
        
        // 애니메이션 리스트 나타내기
        reactor.pulse(\.$animeList)
            .observe(on: MainScheduler.instance)
            .bind(to: mainView.animeListCollectionView.rx.items(cellIdentifier: RecommendCollectionViewCell.identifier, cellType: RecommendCollectionViewCell.self)) { (row, element, cell) in
                cell.configureData(with: element)
            }
            .disposed(by: disposeBag)
        
        // 현재 선택된 정렬 버튼
        reactor.pulse(\.$selectedSortOption)
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, option in
                owner.mainView.sortButtonCollectionView.selectItem(at: IndexPath(item: option.rawValue, section: 0), animated: false, scrollPosition: [])
            }
            .disposed(by: disposeBag)
        
        // 정렬 버튼 탭
        mainView.sortButtonCollectionView.rx.modelSelected(ListSortOption.self)
            .bind(with: self) { owner, option in
                owner.mainView.animeListCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                reactor.action.onNext(.sortSelected(option))
            }
            .disposed(by: disposeBag)
        
        // 애니메이션 셀 선택
        mainView.animeListCollectionView.rx.modelSelected((any AnimeProtocol).self)
            .map { $0.id }
            .bind(with: self) { owner, id in
                reactor.action.onNext(.animeSelected(id))
            }
            .disposed(by: disposeBag)
        
        // 애니메이션 상세화면으로 전환
        reactor.pulse(\.$selectedAnime)
            .compactMap { $0 }
            .bind(with: self) { owner, id in
                let animeDetailViewModel = AnimeDetailViewModel(animeID: id, initialState: AnimeDetailViewModel.State())
                let animeDetailVC = AnimeDetailViewController(reactor: animeDetailViewModel)
                owner.navigationController?.pushViewController(animeDetailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        // sortButtonCollectionView 숨기기/보이기
        reactor.state
            .map { $0.currentEndpoint }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, endpoint in
                if case .animeSearch = endpoint {
                    owner.mainView.sortButtonCollectionView.isHidden = true
                } else {
                    owner.mainView.sortButtonCollectionView.isHidden = false
                }
            }
            .disposed(by: disposeBag)
    }
}
