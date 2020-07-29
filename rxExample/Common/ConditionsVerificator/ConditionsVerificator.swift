//
//  ConditionsVerificator.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import RxSwift

struct ConditionsVerificator<Strategy: VerificationStrategy> {
    
    let verificator: Strategy
    
    init(verificator: Strategy) {
        self.verificator = verificator
    }
    
    func verify(_ value: Strategy.T?) throws -> Observable<Strategy.T> {
        return try verificator.verify(value)
    }
    
}
