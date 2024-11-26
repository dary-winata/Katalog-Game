//
//  SceneDelegate.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 02/11/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let sceneWindows = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: sceneWindows)
        let tabBarViewModel = TabBarViewModel()
        let tabBarController = TabBarViewController(viewModel: tabBarViewModel)
        let navigationController = UINavigationController(rootViewController: tabBarController)

        window.rootViewController = navigationController
        navigationController.navigationBar.prefersLargeTitles = true
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

}
