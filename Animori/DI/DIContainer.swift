//
//  DIContainer.swift
//  Animori
//
//  Created by 이빈 on 4/6/25.
//

import UIKit

final class DIContainer {
    
    static let shared = DIContainer()
    private init() { }
    
    func makeExploreVC() -> ExploreViewController {
        let state = ExploreViewModel.State(topAnime: [], seasonAnime: [], completeAnime: [], movieAnime: [])
        let model = ExploreViewModel(initialState: state)
        let vc = ExploreViewController(reactor: model)
        return vc
    }
    
    func makeAnimeSearchVC() -> AnimeSearchViewController {
        let state = AnimeSearchViewModel.State()
        let model = AnimeSearchViewModel(initialState: state)
        let vc = AnimeSearchViewController(reactor: model)
        return vc
    }
    
    func makeAnimeDetailVC(id: Int) -> AnimeDetailViewController {
        let state = AnimeDetailViewModel.State()
        let model = AnimeDetailViewModel(animeID: id, initialState: state)
        let vc = AnimeDetailViewController(reactor: model)
        return vc
    }
    
    func makeAnimeListVC() -> AnimeListViewController {
        let state = AnimeListViewModel.State(animeList: [])
        let model = AnimeListViewModel(initialState: state)
        let vc = AnimeListViewController(reactor: model)
        return vc
    }
    
    func makeTabBarVC() -> AnimoriTabBarController {
        let vc = AnimoriTabBarController()
        vc.viewControllers = [
            UINavigationController(rootViewController: makeExploreVC()),
            UINavigationController(rootViewController: makeAnimeSearchVC())
        ]
        return vc
    }
    
    func makeAlert(retryAction: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(
            title: "네트워크 오류 발생",
            message: "네트워크 오류가 발생했습니다. 다시 시도해 주세요.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .default))
        
        if let retryAction = retryAction {
            alert.addAction(UIAlertAction(title: "다시 시도", style: .default) { _ in
                retryAction()
            })
        }
        
        return alert
    }
    
}
