//
//  SceneDelegate.swift
//  TicTacToe-SwiftUI
//
//  Created by Joshua Homann on 3/28/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }

    let tabbarViewController = UITabBarController()
    let boardView = UIHostingController(rootView: BoardView())
    boardView.tabBarItem.title = "SwiftUI"
    boardView.tabBarItem.image = UIImage(systemName: "star") ?? UIImage()
    let boardViewController = BoardViewController(viewModel: .init())
    boardViewController.tabBarItem.title = "UIKit"
    boardViewController.tabBarItem.image = UIImage(systemName: "circle") ?? UIImage()
    tabbarViewController.addChild(boardView)
    tabbarViewController.addChild(boardViewController)
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = tabbarViewController
    window.makeKeyAndVisible()
    self.window = window
  }
}

