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
        self.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 1)
    }
    
    override func configureNavigation() { title = "검색" }

    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<AnimeSearchSection> { dataSource, collectionView, indexPath, item in
        switch item {
        case .recentSearch(let id, let keyword):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCell.identifier, for: indexPath) as! RecentSearchCell
            cell.configureData(with: id, keyword: keyword)
            cell.onRemoveTapped = { [weak self] id, keyword in
                guard let self else { return }
                self.reactor?.action.onNext(.removeRecentSearch(id, keyword))
            }
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
        if indexPath.section > 1 {
            header.configure(with: section.header)
        } else {
            header.configureWithoutArrow(with: section.header)
        }
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
                                                        items: state.recentKeywords.map { .recentSearch($0.id.stringValue, $0.keyword) })
                
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
            .map { AnimeSearchViewModel.Action.search($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 검색 -> 화면 전환
        reactor.pulse(\.$searchedKeyword)
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .bind(with: self) { owner, keyword in
                let state = AnimeListViewModel.State(animeList: [])
                let model = AnimeListViewModel(initialState: state)
                let vc = AnimeListViewController(reactor: model)
                model.action.onNext(.loadAnimeList(.animeSearch(keyword, .scoredBy)))
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$selectedGenre)
            .compactMap { $0 }
            .bind(with: self) { owner, genre in
                let state = AnimeListViewModel.State(animeList: [])
                let model = AnimeListViewModel(initialState: state)
                let vc = AnimeListViewController(reactor: model)
                model.action.onNext(.loadAnimeList(.animeByGenre(genre, .scoredBy)))
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 애니메이션 상세화면으로 전환
        reactor.pulse(\.$selectedAnime)
            .compactMap { $0 }
            .bind(with: self) { owner, id in
                let animeDetailVC = DIContainer.shared.makeAnimeDetailVC(id: id)
                owner.navigationController?.pushViewController(animeDetailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 장르 탭
        mainView.collectionView.rx.modelSelected(AnimeSearchSectionItem.self)
            .subscribe(with: self) { owner, item in
                switch item {
                case .recentSearch(_, let keyword):
                    reactor.action.onNext(.search(keyword))
                case .genreSearch(let genre):
                    reactor.action.onNext(.genreSelected(genre))
                case .topAnime(let anime):
                    reactor.action.onNext(.animeSelected(anime.id))
                case .topCharacter(let character):
                    print("캐릭터 선택", character.name)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
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

