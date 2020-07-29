//
//  VerificationStrategy.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import RxSwift

protocol VerificationStrategy {
    associatedtype T
    
    func verify(_ value: T?) throws -> Observable<T>
}
