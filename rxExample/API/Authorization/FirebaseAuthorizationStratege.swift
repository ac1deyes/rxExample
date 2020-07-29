//
//  FirebaseAuthorizationStratege.swift
//  rxExample
//
//  Created by Vladislav on 06.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth

class FirebaseAuthorizationStratege: AuthorizationStrategy {
    
    func signIn(_ email: String, password: String) -> Observable<User> {
        return Observable.create { (observer) -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                do {
                   let user = try User.fromFirebase(result)
                    observer.onNext(user)
                } catch let error {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func signUp(_ email: String, password: String) -> Observable<User> {
        return Observable.create { (observer) -> Disposable in
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                do {
                   let user = try User.fromFirebase(result)
                    observer.onNext(user)
                } catch let error {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
}
