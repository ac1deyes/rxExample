//
//  AuthorizationError.swift
//  rxExample
//
//  Created by Vladislav on 14.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation

enum AuthorizationError: Error {
    case unexpected
    
    var localizedDescription: String {
        switch self {
        case .unexpected: return "Unexpected error"
        }
    }
}
