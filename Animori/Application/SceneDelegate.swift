//
//  SceneDelegate.swift
//  Animori
//
//  Created by 이빈 on 3/27/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var pendingDeeplinkURL: URL?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = DIContainer.shared.makeTabBarVC()
        window?.makeKeyAndVisible()
        
        // 👉 URLContexts에도 딥링크가 있는 경우 처리
        if let url = connectionOptions.urlContexts.first?.url {
            handleDeeplink(url)
        }
        
        // 👉 혹시 저장된 게 있다면 여기서 처리
        if let pending = pendingDeeplinkURL {
            handleDeeplink(pending)
            pendingDeeplinkURL = nil
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        // window가 아직 준비되지 않은 경우, URL만 저장
        if window?.rootViewController == nil {
            pendingDeeplinkURL = url
            return
        }
        
        handleDeeplink(url)
    }
    
    func handleDeeplink(_ url: URL) {
        guard url.scheme == "animori",
              url.host == "anime",
              let idString = url.pathComponents.dropFirst().first,
              let animeID = Int(idString),
              let tabBar = window?.rootViewController as? AnimoriTabBarController
        else { return }

        tabBar.selectedIndex = 0

        guard let nav = tabBar.selectedViewController as? UINavigationController else { return }

        let exploreVC = DIContainer.shared.makeExploreVC()
        let detailVC = DIContainer.shared.makeAnimeDetailVC(id: animeID)
        nav.setViewControllers([exploreVC, detailVC], animated: true)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

