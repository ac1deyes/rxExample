//
//  AuthorizationManager.swift
//  rxExample
//
//  Created by Vladislav on 06.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import RxSwift

class AuthorizationManager<Strategy: AuthorizationStrategy> {
    
    private let strategy: Strategy
    
    init(strategy: Strategy) {
        self.strategy = strategy
    }
    
    func signIn(email: String, password: String) -> Observable<User> {
        return strategy.signIn(email, password: password)
    }
    
    func signUp(email: String, password: String) -> Observable<User> {
        return strategy.signUp(email, password: password)
    }
}
