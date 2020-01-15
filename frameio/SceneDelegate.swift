//
//  SceneDelegate.swift
//  frameio
//
//  Created by Vlad Z. on 1/14/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

import UIKit

class SceneDelegate:
    UIResponder,
    UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScheme = scene as? UIWindowScene else { return }
        
        window = UIWindow(windowScene: windowScheme)
        window?.makeKeyAndVisible()
    }
}

