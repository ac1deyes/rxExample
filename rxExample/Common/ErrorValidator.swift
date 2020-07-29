//
//  ErrorValidator.swift
//  rxExample
//
//  Created by Vladislav on 06.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import FirebaseAuth

class ErrorValidator {
    static func validate(_ error: Error) -> String {
        switch error {
        case let error where error is VerificationError:
            let error = error as! VerificationError
            switch error {
            case .wrongEmail (let message),
                 .wrongPassword (let message):
                return message
            case .unexpected:
                return "Unexpecred error"
            }
        default: return error.localizedDescription
        }
    }
}

extension ErrorValidator {
    static func toAlert(_ error: Error) -> Alert {
        let action = AlertAction(title: "Ok")
        return Alert(title: ErrorValidator.validate(error), actions: [action])
    }
}
