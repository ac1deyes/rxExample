//
//  Swift + Extensions.swift
//  rxExample
//
//  Created by Vladislav on 22.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
