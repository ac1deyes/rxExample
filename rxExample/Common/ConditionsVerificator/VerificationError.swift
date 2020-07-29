//
//  VerificationError.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation

enum VerificationError: Error {
    case wrongEmail(String)
    case wrongPassword(String)
    case unexpected
}
