//
//  ViewModelType.swift
//  rxExample
//
//  Created by Vladislav on 22.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation


protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
