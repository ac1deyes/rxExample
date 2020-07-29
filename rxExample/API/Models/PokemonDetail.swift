//
//  PokemonData.swift
//  rxExample
//
//  Created by Vladislav on 22.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation

struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    
    let baseExperience: Int
    
    let weight:Int
    let height: Int
}
