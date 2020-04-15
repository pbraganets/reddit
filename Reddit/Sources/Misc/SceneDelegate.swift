//
//  SceneDelegate.swift
//  Reddit
//
//  Created by Pavlo B on 16.04.2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController)
        coordinator = MainCoordinator(with: router)
        coordinator?.start()
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }

}
