//
//  AlertAction.swift
//  rxExample
//
//  Created by Vladislav on 06.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import UIKit

struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let action: ((UIAlertAction)-> Void)?
    
    init(title: String, style: UIAlertAction.Style = .default, action: ((UIAlertAction)-> Void)? = nil) {
        self .title = title
        self.style = style
        self.action = action
    }
}
