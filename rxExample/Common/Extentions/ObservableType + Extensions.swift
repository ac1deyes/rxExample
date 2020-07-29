//
//  ObservableType + Extensions.swift
//  rxExample
//
//  Created by Vladislav on 23.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    func withPrevious(startWith first: Element) -> Observable<(Element, Element)> {
        return scan((first, first)) { ($0.1, $1) }.skip(1)
    }
}
