//
//  AnimeDetailViewController.swift
//  Animori
//
//  Created by 이빈 on 4/1/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

final class AnimeDetailViewController: BaseViewController<AnimeDetailView> {
    
    private let sectionsRelay = BehaviorRelay<[AnimeDetailSection]>(value: [])
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(reactor: AnimeDetailViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "애니메이션 상세"
    }
    
    // RxDataSources: 섹션 모델을 사용
    private var dataSource = RxCollectionViewSectionedReloadDataSource<AnimeDetailSection>(
        configureCell: { dataSource, collectionView, indexPath, item in
            switch item {
            case .review(let review):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.identifier, for: indexPath) as! ReviewCell
                cell.configureData(review)
                return cell
                
            case .character(let character):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath) as! CharacterCell
                cell.configureData(character)
                return cell
                
            case .ott(let ott):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OTTCell.identifier, for: indexPath) as! OTTCell
                cell.configureData(title: ott.name)
                return cell
                
            case .recommend(let recommend):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as! RecommendCollectionViewCell
                cell.configureRecommendData(with: recommend)
                return cell
            }
        },
        configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: AnimeDetailSectionView.identifier,
                for: indexPath
            ) as! AnimeDetailSectionView
            let section = dataSource.sectionModels[indexPath.section]
            header.configure(with: section.header)
            return header
        }
    )
}

extension AnimeDetailViewController: View {
    // MARK: - Bind
    func bind(reactor: AnimeDetailViewModel) {
        reactor.action.onNext(.loadDetailInfo)
        
        // 상세정보 바인딩 (상단 정보)
        reactor.state
            .map { $0.animeDetail }
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] detail in
                self?.mainView.configureData(anime: detail)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { state -> [AnimeDetailSection] in
            let reviewSection = AnimeDetailSection(header: "리뷰",
                                                   items: state.reviews.map { .review($0) })
            
            let characterSection = AnimeDetailSection(header: "캐릭터",
                                                      items: state.characters.map { .character($0) })
            
            let ottSection = AnimeDetailSection(header: "OTT 바로가기",
                                                items: state.animeDetail.OTT.map { .ott($0) })
            
            let recommendSection = AnimeDetailSection(header: "비슷한 애니메이션 추천",
                                                      items: state.similarAnime.map { .recommend($0) })
            
            return [reviewSection, characterSection, ottSection, recommendSection]
        }
        .bind(to: sectionsRelay)
        .disposed(by: disposeBag)
        
        sectionsRelay
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

