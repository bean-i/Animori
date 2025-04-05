//
//  AnimeSearchViewController.swift
//  Animori
//
//  Created by 이빈 on 4/4/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources

final class AnimeSearchViewController: BaseViewController<AnimeSearchView> {
    
    private let sectionRelay = BehaviorRelay<[AnimeSearchSection]>(value: [])
    var disposeBag = DisposeBag()
    
    init(reactor: AnimeSearchViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    override func configureNavigation() { title = "검색" }

    private var dataSource = RxCollectionViewSectionedReloadDataSource<AnimeSearchSection> { dataSource, collectionView, indexPath, item in
        switch item {
        case .recentSearch(let recentKeywords):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCell.identifier, for: indexPath) as! RecentSearchCell
            cell.configureData(with: recentKeywords)
            return cell
            
        case .genreSearch(let genres):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreSearchCell.identifier, for: indexPath) as! GenreSearchCell
            cell.configureData(with: genres)
            return cell
            
        case .topAnime(let anime):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as! RecommendCollectionViewCell
            cell.configureData(with: anime)
            return cell
            
        case .topCharacter(let character):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterInfoCell.identifier, for: indexPath) as! CharacterInfoCell
            cell.configureData(with: character)
            return cell
        }
    } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as! SectionHeaderView
        let section = dataSource.sectionModels[indexPath.section]
        header.configure(with: section.header)
        return header
    }
}

extension AnimeSearchViewController: View {
    
    func bind(reactor: AnimeSearchViewModel) {
        // 데이터 로드
        reactor.action.onNext(.loadInfo)
        
        // 섹션 구성
        reactor.state
            .map { state -> [AnimeSearchSection] in
                let keywordSection = AnimeSearchSection(header: "최근 검색어",
                                                        items: state.recentKeywords.map { .recentSearch($0) })
                
                let genreSection = AnimeSearchSection(header: "장르 바로가기",
                                                      items: state.genres.map { .genreSearch($0) })
                
                let topAnimeSection = AnimeSearchSection(header: "Top 애니메이션",
                                                         items: state.topAnimes.map { .topAnime($0) })
                
                let topCharacterSection = AnimeSearchSection(header: "Top 캐릭터",
                                                             items: state.topCharacters.map { .topCharacter($0) })
                
                return [keywordSection, genreSection, topAnimeSection, topCharacterSection]
            }
            .bind(to: sectionRelay)
            .disposed(by: disposeBag)
        
        // 섹션 적용
        sectionRelay
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 키보드 내리기
        Observable.merge(
            mainView.tapGesture.rx.event.map { _ in },
            mainView.collectionView.rx.didScroll.map { _ in }
        )
        .bind(with: self, onNext: { owner, _ in
            owner.view.endEditing(true)
        })
        .disposed(by: disposeBag)

        // 검색
        mainView.searchBar.rx.searchButtonClicked
            .withLatestFrom(mainView.searchBar.rx.text.orEmpty)
            .bind(with: self) { owner, keyword in
                let state = AnimeListViewModel.State(animeList: [])
                let model = AnimeListViewModel(initialState: state)
                let vc = AnimeListViewController(reactor: model)
                model.action.onNext(.loadAnimeList(.animeSearch(keyword)))
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}
