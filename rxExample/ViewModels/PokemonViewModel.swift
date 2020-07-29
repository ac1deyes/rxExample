//
//  FeedViewModel.swift
//  rxExample
//
//  Created by Vladislav on 06.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import RxSwift

class PokemonViewModel {
    
    var pokemon: Observable<PokemonDetail>!
    var loading: Observable<Bool>!
    
    private let sceneCoordinator: SceneCoordinatorType
    private(set) var pokemonShort: PokemonShort
    
    init(coordinator: SceneCoordinatorType, pokemon: PokemonShort) {
        self.sceneCoordinator = coordinator
        self.pokemonShort = pokemon
        
        self.pokemon = fetchData(pokemon).share()
        self.loading = self.pokemon.map { _ in false }.share()

    }
    
    // MARK: - Network
    
    private func fetchData(_ pokemon: PokemonShort) -> Observable<PokemonDetail> {
        return PokemonAPI.fetchPokemon(pokemon)
    }

}
