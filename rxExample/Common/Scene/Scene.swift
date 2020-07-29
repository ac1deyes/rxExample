//
//  Scene.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation

enum Scene {
    case authorization(AuthorizationViewModel)
    case pokemonList(PokemonListViewModel)
    case pokemon(PokemonViewModel)
    case termsOfUse(TermsOfUseViewModel)
    
    case alert(Alert)
}
