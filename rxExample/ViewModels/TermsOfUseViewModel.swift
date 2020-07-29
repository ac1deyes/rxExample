//
//  TermsOfUseViewModel.swift
//  rxExample
//
//  Created by Vladislav on 24.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import Action

class TermsOfUseViewModel {
    
    private(set) var url: URL
    
    let onCancel: CocoaAction
    
    init(coordinator: SceneCoordinatorType, url: URL) {
        self.url = url
        
        onCancel = CocoaAction {
            return coordinator.pop()
                .asObservable()
                .map { _ in }
        }
    }
}
