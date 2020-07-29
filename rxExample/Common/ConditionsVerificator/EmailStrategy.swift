//
//  EmailStrategy.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import RxSwift

struct EmailStrategy: VerificationStrategy {
    typealias T = String
    
    func verify(_ value: T?) throws -> Observable<T> {
        
        return Observable.just(value).map { (value) in
            guard let email = value, email.count > 0 else {
                throw VerificationError.wrongEmail("Enter e-mail")
            }
            guard self.isValidEmail(email) else {
                throw VerificationError.wrongEmail("E-mail entered incorrectly")
            }
            return email
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
