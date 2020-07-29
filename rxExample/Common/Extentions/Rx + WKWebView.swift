//
//  Rx + WKWebView.swift
//  rxExample
//
//  Created by Vladislav on 24.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import WebKit
import RxSwift
import RxCocoa

extension Reactive where Base: WKWebView {
    public var estimatedProgress: Observable<Double> {
        return self.observeWeakly(Double.self, "estimatedProgress")
            .map { $0 ?? 0.0 }
    }
}


