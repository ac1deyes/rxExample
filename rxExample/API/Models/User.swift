//
//  User.swift
//  rxExample
//
//  Created by Vladislav on 06.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
    var token: String
    var email: String?
    
    init?(token: String?, email: String?) {
        guard let token = token else { return nil }
        self.token = token
        self.email = email
    }
    
}

extension User {
    static func fromFirebase(_ data: AuthDataResult?) throws -> User {
        guard let user = User(token: data?.user.refreshToken, email: data?.user.email) else {
            throw AuthorizationError.unexpected
        }
        return user
    }
}
