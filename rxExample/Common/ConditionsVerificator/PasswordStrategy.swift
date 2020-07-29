//
//  PasswordStrategy.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import RxSwift

struct PasswordStrategy: VerificationStrategy {
    typealias T = String
    
    func verify(_ value: T?) throws -> Observable<T> {
        return Observable.just(value).map { (value) in
            guard let password = value, password.count > 0  else {
                throw VerificationError.wrongPassword("Enter password")
            }
            
            let passwordMinLenght = 8
            let passwordMaxLenght = 30
            
            guard (passwordMinLenght...passwordMaxLenght).contains(password.count) else {
                throw VerificationError.wrongPassword("Invalid password entered")
            }
            return password
        }
    }
}
