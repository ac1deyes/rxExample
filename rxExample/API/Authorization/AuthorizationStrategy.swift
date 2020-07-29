//
//  LoginStratege.swift
//  rxExample
//
//  Created by Vladislav on 06.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthorizationStrategy {
    func signIn(_ email: String, password: String) -> Observable<User>
    func signUp(_ email: String, password: String) -> Observable<User>
}
