//
//  Alert.swift
//  rxExample
//
//  Created by Vladislav on 06.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation

struct Alert {
    let title: String?
    let message: String?
    let actions: [AlertAction]?
    
    init(title: String? = nil, message: String? = nil, actions: [AlertAction]? = nil) {
        self.title = title
        self.message = message
        self.actions = actions
    }
}
