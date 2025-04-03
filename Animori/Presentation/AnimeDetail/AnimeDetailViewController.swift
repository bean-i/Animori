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
import SafariServices

final class AnimeDetailViewController: BaseViewController<AnimeDetailView> {
    
    private let sectionsRelay = BehaviorRelay<[AnimeDetailSection]>(value: [])
    var disposeBag = DisposeBag()
    
    init(reactor: AnimeDetailViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

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
    func bind(reactor: AnimeDetailViewModel) {
        // 네트워크 요청 시작 전에 로딩 인디케이터 표시
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, isLoading in
                if isLoading {
                    Loading.shared.showLoading(in: owner.mainView)
                } else {
                    Loading.shared.hideLoading(from: owner.mainView)
                }
            }
            .disposed(by: disposeBag)
        
        // 데이터 로드 액션
        reactor.action.onNext(.loadDetailInfo)
        
        // 상세정보 바인딩 (상단 정보)
        reactor.state
            .map { $0.animeDetail }
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] detail in
                self?.mainView.configureData(anime: detail)
                self?.navigationItem.title = detail.title
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .observe(on: MainScheduler.instance)
            .map { state -> [AnimeDetailSection] in
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
        
        // 데이터 통신이 끝난 이후, 레이아웃 업데이트 후 로딩 인디케이터 숨김
        sectionsRelay
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                DispatchQueue.main.async {
                    owner.mainView.collectionView.reloadData()
                    owner.mainView.collectionView.collectionViewLayout.invalidateLayout()
                    let contentHeight = owner.mainView.collectionView.collectionViewLayout.collectionViewContentSize.height
                    owner.mainView.collectionViewHeightConstraint?.update(offset: max(contentHeight, 100))
                    owner.mainView.layoutIfNeeded()
                }
            }
            .disposed(by: disposeBag)
        
        // OTT 셀 탭 액션
        mainView.collectionView.rx.modelSelected(AnimeDetailSectionItem.self)
            .subscribe(onNext: { item in
                switch item {
                case .ott(let ott):
                    print("\(ott.name)선택!!!, \(ott.url)로 이동 ㄱㄱ")
                    reactor.action.onNext(.ottTapped(ott.url))
                default: break
                }
            })
            .disposed(by: disposeBag)
        
        // OTT 셀 탭 -> 사파리 화면 띄우기
        reactor.state
            .map { $0.ottURL }
            .compactMap { $0 }
            .bind(with: self) { owner, url in
                let safariVC = SFSafariViewController(url: url)
                owner.present(safariVC, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}
