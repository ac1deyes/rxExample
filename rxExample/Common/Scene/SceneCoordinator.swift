//
//  SceneCoordinator.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class SceneCoordinator: NSObject, SceneCoordinatorType {
    
    private var window: UIWindow
    private var currentViewController: UIViewController?
    
    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController
    }
    
    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.last!
        } else if let tabBarController = viewController as? UITabBarController {
            let vc = tabBarController.selectedViewController ?? tabBarController.viewControllers!.first!
            if let navigationController = vc as? UINavigationController {
                return navigationController.viewControllers.last!
            }
            return vc
        } else {
            return viewController
        }
    }
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
        let subject = PublishSubject<Void>()
        let viewController = scene.viewController()
        switch type {
        case .root:
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            currentViewController?.navigationController?.delegate = self
            window.rootViewController = viewController
            subject.onCompleted()
            
        case .push:
            guard let navigationController = currentViewController?.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            
            navigationController.delegate = self
            
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            navigationController.pushViewController(viewController, animated: true)
            
        case .modal:
            currentViewController?.present(viewController, animated: true) {
                subject.onCompleted()
            }
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            
        case .alert:
            guard let root = UIApplication.shared.keyWindow?.rootViewController else { break }
            root.present(viewController, animated: true) {
                subject.onCompleted()
            }
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    @discardableResult
    func pop(count: Int, animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        if let presenter = currentViewController?.presentingViewController {
            // dismiss a modal controller
            guard count == 1 else {
                fatalError("can't dismiss more then 1 modal controller")
            }
            currentViewController?.dismiss(animated: animated) {
                self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
                subject.onCompleted()
            }
        } else if let navigationController = currentViewController?.navigationController {
            
            
            if count == 1 {
                _ = navigationController.rx.delegate
                    .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                    .map { _ in }
                    .bind(to: subject)
                
                guard navigationController.popViewController(animated: animated) != nil else {
                    fatalError("can't navigate back from \(String(describing: currentViewController))")
                }
            } else {
                guard let vc = navigationController.viewControllers[safe: navigationController.viewControllers.count-count-1] else {
                    fatalError("can't \(count) controllers")
                }
                
                _ = navigationController.rx.delegate
                    .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                    .map { _ in }
                    .bind(to: subject)
                
                guard navigationController.popToViewController(vc, animated: true) != nil else {
                    fatalError("can't navigate back to \(vc)")
                }
            }
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(String(describing: currentViewController))")
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    @discardableResult
    func popToRoot(animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        if let presenter = currentViewController?.presentingViewController {
            // dismiss a modal controller
            currentViewController?.dismiss(animated: animated) {
                self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
                subject.onCompleted()
            }
        } else if let navigationController = currentViewController?.navigationController {
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            guard navigationController.popToRootViewController(animated: animated) != nil else {
                fatalError("can't navigate back from \(String(describing: currentViewController))")
            }
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(String(describing: currentViewController))")
        }
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
}

extension SceneCoordinator: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        currentViewController = viewController
    }
    
}
