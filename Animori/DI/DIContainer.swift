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
    
    func makeAnimeListVC(endpoint: AnimeEndPoint, mode: AnimeListViewModel.AnimeMode) -> AnimeListViewController {
        let state = AnimeListViewModel.State(currentEndpoint: endpoint)
        let model = AnimeListViewModel(initialState: state, mode: mode)
        let vc = AnimeListViewController(reactor: model)
        return vc
    }
    
    func makeAnimeCharacterListVC(mode: AnimeCharacterListViewModel.CharacterMode) -> AnimeCharacterListViewController {
        let state = AnimeCharacterListViewModel.State()
        let model: AnimeCharacterListViewModel
        switch mode {
        case .anime(let id):
            model = AnimeCharacterListViewModel(initialState: state, mode: .anime(id: id))
        case .top:
            model = AnimeCharacterListViewModel(initialState: state, mode: .top)
        }
        let vc = AnimeCharacterListViewController(reactor: model)
        return vc
    }
    
    func makeCharacterDetailVC(id: Int) -> AnimeCharacterDetailViewController {
        let state = AnimeCharacterDetailViewModel.State()
        let model = AnimeCharacterDetailViewModel(initialState: state, characterID: id)
        let vc = AnimeCharacterDetailViewController(reactor: model)
        return vc
    }
    
    func makeStorageVC() -> StorageViewController {
        let state = StorageViewModel.State()
        let model = StorageViewModel(initialState: state)
        let vc = StorageViewController(reactor: model)
        return vc
    }
    
    func makeTabBarVC() -> AnimoriTabBarController {
        let vc = AnimoriTabBarController()
        vc.viewControllers = [
            UINavigationController(rootViewController: makeExploreVC()),
            UINavigationController(rootViewController: makeAnimeSearchVC()),
            UINavigationController(rootViewController: makeStorageVC())
        ]
        return vc
    }
    
    func makeAlert(retryAction: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(
            title: LocalizedStrings.Alert.title,
            message: LocalizedStrings.Alert.message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: LocalizedStrings.Alert.cancel, style: .default))
        
        if let retryAction = retryAction {
            alert.addAction(UIAlertAction(title: LocalizedStrings.Alert.retry, style: .default) { _ in
                retryAction()
            })
        }
        
        return alert
    }
    
}
