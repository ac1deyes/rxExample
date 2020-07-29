//
//  SceneCoordinatorType.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable
    
    
    @discardableResult
    func pop(count: Int, animated: Bool) -> Completable
    
    @discardableResult
    func popToRoot(animated: Bool) -> Completable
}

extension SceneCoordinatorType {
    @discardableResult
    func pop() -> Completable {
        return pop(count:1, animated: true)
    }
    
    @discardableResult
    func popToRoot() -> Completable {
        return popToRoot(animated: true)
    }
}
