//
//  Collection + Extensions.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index?) -> Element? {
        guard let index = index else { return nil }
        return indices.contains(index) ? self[index] : nil
    }
}


extension Collection where Element == [String: Any]  {
    func decode<T: Decodable>() -> [T] {
        self.compactMap({ (model) -> T? in
            guard let data = try? JSONSerialization.data(withJSONObject: model, options: []),
                let pokemon = try? JSONDecoder().decode(T.self, from: data) else {
                    return nil
            }
            return pokemon
        })
    }
}
