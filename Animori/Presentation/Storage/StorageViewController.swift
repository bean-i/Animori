//
//  StorageViewController.swift
//  Animori
//
//  Created by 이빈 on 4/12/25.
//

import UIKit
import ReactorKit
import RxCocoa
import RxDataSources

final class StorageViewController: BaseViewController<StorageView> {
    
    private let sectionsRelay = BehaviorRelay<[StorageSection]>(value: [])
    var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reactor?.action.onNext(.loadStorage)
    }
    
    init(reactor: StorageViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        self.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "tray.fill"), tag: 0)
    }
    
    override func configureNavigation() {
        title = LocalizedStrings.MyLibrary.library
    }
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<StorageSection>(
        configureCell: { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendCollectionViewCell.identifier,
                for: indexPath
            ) as! RecommendCollectionViewCell
            switch item {
            case .watching(let anime),
                    .planned(let anime),
                    .finished(let anime):
                cell.configureStorageData(with: anime)
            }
            return cell
        },
        configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.identifier,
                for: indexPath
            ) as! SectionHeaderView
            let section = dataSource.sectionModels[indexPath.section]
            header.configureWithoutArrow(with: section.header)
            return header
        }
    )
    
}

extension StorageViewController: View {
    
    func bind(reactor: StorageViewModel) {
        reactor.action.onNext(.loadStorage)
        
        sectionsRelay
            .bind(to: mainView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.sections }
            .bind(to: sectionsRelay)
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.modelSelected(StorageSectionItem.self)
            .bind(with: self) { owner, item in
                let id: Int
                switch item {
                case .finished(let anime): id = anime.animeId
                case .planned(let anime): id = anime.animeId
                case .watching(let anime): id = anime.animeId
                }
                let vc = DIContainer.shared.makeAnimeDetailVC(id: id)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}
