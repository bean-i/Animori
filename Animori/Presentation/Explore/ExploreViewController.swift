//
//  ExploreViewController.swift
//  Animori
//
//  Created by 이빈 on 3/28/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources

final class ExploreViewController: BaseViewController<ExploreView> {
    
    // 섹션 배열
    private let sectionsRelay = BehaviorRelay<[ExploreSection]>(value: [])

    var disposeBag = DisposeBag()
    
    init(reactor: ExploreViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        self.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), tag: 0)
    }
    
    // 밑 컬렉션뷰 2개에서 화면 전환하면, 정렬 탭 UI가 초기화되는 버그..
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if !(reactor?.isLoading ?? false) { // 요청 중이 아니면 다시 시도
//            reactor?.action.onNext(.loadAnime)
//        }
        if let selectedSort = reactor?.currentState.selectedSortOption {
            let indexPath = IndexPath(item: selectedSort.rawValue, section: 0)
            mainView.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }
    
    // RxDataSources diff 기반 업데이트
    private lazy var dataSource = RxCollectionViewSectionedAnimatedDataSource<ExploreSection>(
        configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            switch item {
            case .sort(let sortOption):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SortButtonCell.identifier, for: indexPath) as! SortButtonCell
                cell.configureData(title: sortOption.displayName)
                return cell
                
            case .topAnime(let animeArray):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendCollectionViewCell.identifier, for: indexPath) as! TrendCollectionViewCell
                cell.configure(with: animeArray)
                cell.delegate = self
                return cell
                
            case .seasonAnime(let anime):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as! RecommendCollectionViewCell
                cell.configureData(with: anime)
                return cell
                
            case .completeAnime(let anime):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as! RecommendCollectionViewCell
                cell.configureData(with: anime)
                return cell
                
            case .shortAnime(let anime):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as! RecommendCollectionViewCell
                cell.configureData(with: anime)
                return cell
            }
        },
        configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader,
               let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView {
                headerView.configure(with: dataSource[indexPath.section].header)
                headerView.delegate = self
                headerView.tag = indexPath.section// tag 설정
                return headerView
            }
            return UICollectionReusableView()
        }
    )
}

extension ExploreViewController: View {
    func bind(reactor: ExploreViewModel) {

        reactor.action.onNext(.loadAnime)
        
        // Reactor의 state를 섹션 배열로 매핑
        reactor.state.map { state -> [ExploreSection] in
            let section0 = ExploreSection(header: "Sort",
                                          items: state.sort.map { .sort($0) })
            
            let section1 = ExploreSection(header: "TopAnime",
                                          items: [.topAnime(state.topAnime)])
            
            let section2 = ExploreSection(header: RecommendOption.season.displayName,
                                          items: state.seasonAnime.map { .seasonAnime($0) })
            
            let section3 = ExploreSection(header: RecommendOption.complete.displayName,
                                          items: state.completeAnime.map { .completeAnime($0) })
            
            let section4 = ExploreSection(header: RecommendOption.short.displayName,
                                          items: state.movieAnime.map { .shortAnime($0) })
            
            return [section0, section1, section2, section3, section4]
        }
        .observe(on: MainScheduler.instance)
        .bind(to: sectionsRelay)
        .disposed(by: disposeBag)
        
        // Relay를 컬렉션뷰에 바인딩 (애니메이션 기반 업데이트)
        sectionsRelay
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 셀 선택 처리
        mainView.collectionView.rx.modelSelected(ExploreItem.self)
            .subscribe(onNext: { item in
                switch item {
                case .seasonAnime(let anime), .completeAnime(let anime), .shortAnime(let anime):
                    reactor.action.onNext(.animeSelected(anime.id))
                case .sort(let sortOption):
                    reactor.action.onNext(.sortSelected(sortOption))
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        // 애니메이션 상세화면으로 전환
        reactor.pulse(\.$selectedAnime)
            .compactMap { $0 }
            .bind(with: self) { owner, id in
                let animeDetailVC = DIContainer.shared.makeAnimeDetailVC(id: id)
                owner.navigationController?.pushViewController(animeDetailVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                let alert = DIContainer.shared.makeAlert(retryAction: {
                    owner.reactor?.action.onNext(.loadAnime)
                })
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// FSPagerView를 사용하는 셀 내부 선택 delegate
extension ExploreViewController: TrendCollectionViewCellDelegate {
    func trendCollectionViewCellTapped(_ cell: TrendCollectionViewCell, didSelectAnime anime: any AnimeProtocol) {
        reactor?.action.onNext(.animeSelected(anime.id))
    }
}

// 헤더 탭 -> 애니메이션 목록 화면으로 전환
extension ExploreViewController: SectionHeaderViewDelegate {
    func sectionHeaderViewTapped(_ headerView: SectionHeaderView) {
        let sectionIndex = headerView.tag
        if sectionIndex >= 2 {
            let state = AnimeListViewModel.State(animeList: [])
            let model = AnimeListViewModel(initialState: state)
            let animeListVC = AnimeListViewController(reactor: model)
            
            switch sectionIndex {
            case 2:
                model.action.onNext(.loadAnimeList(.seasonNow))
            case 3:
                model.action.onNext(.loadAnimeList(.completeAnime(.scoredBy)))
            case 4:
                model.action.onNext(.loadAnimeList(.movieAnime(.scoredBy)))
            default: break
            }
            navigationController?.pushViewController(animeListVC, animated: true)
        }
    }
}
