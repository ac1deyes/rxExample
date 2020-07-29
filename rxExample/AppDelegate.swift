//
//  AppDelegate.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var sceneCoordinator: SceneCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        prepareWindow()
        transitionToFirstScene()
        
        return true
    }

    private func prepareWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        self.window = window
        window.makeKeyAndVisible()
        sceneCoordinator = SceneCoordinator(window: window)
    }
    
    private func transitionToFirstScene() {
        sceneCoordinator.transition(to: initialScene(), type: .root)
    }
    
    private func initialScene() -> Scene {
        let authorizationViewModel = AuthorizationViewModel(coordinator: sceneCoordinator)
        let firstScene = Scene.authorization(authorizationViewModel)
        return firstScene
    }
    
}

