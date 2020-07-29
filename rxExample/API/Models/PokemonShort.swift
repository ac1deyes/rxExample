//
//  Pokemon.swift
//  rxExample
//
//  Created by Vladislav on 14.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation

struct PokemonShort {
    var id: Int { return Int(URL(string: url)?.lastPathComponent ?? "0") ?? 0 }
    
    let name: String
    let url: String
}

extension PokemonShort: Decodable {
    
    enum CodingKeys: CodingKey {
        case name, url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name).capitalizingFirstLetter()
        self.url = try container.decode(String.self, forKey: .url)
    }
}
