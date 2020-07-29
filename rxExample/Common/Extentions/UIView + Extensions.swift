//
//  UIView + Extensions.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import UIKit

extension UIView {
    func layoutAnimated(_ animated: Bool = true, duration: Double = 0.3 , delay: Double = 0) {
        if animated {
            UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            })
        } else {
            UIView.performWithoutAnimation {
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
}
