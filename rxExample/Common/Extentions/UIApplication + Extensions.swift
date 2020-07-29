//
//  UIApplication + Extensions.swift
//  rxExample
//
//  Created by Vladislav on 06.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var safeAreaTopInset: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        }
        return 0
    }
    
    var safeAreaBottomInset: CGFloat {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        return 0
    }

}
