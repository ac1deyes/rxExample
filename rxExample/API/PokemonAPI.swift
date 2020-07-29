//
//  FeedAPI.swift
//  rxExample
//
//  Created by Vladislav on 06.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import RxSwift

class PokemonAPI  {
    
    static let shared = PokemonAPI()
    
    private let networkDataFetcher = NetworkDataFetcher.shared
    
    private init() { }
    
    static func signIn<Strategy: AuthorizationStrategy>(email: String, password: String, strategy: Strategy) -> Observable<User> {
        return AuthorizationManager(strategy: strategy).signIn(email: email, password: password)
    }
    
    static func signUp<Strategy: AuthorizationStrategy>(email: String, password: String, strategy: Strategy) -> Observable<User> {
        return AuthorizationManager(strategy: strategy).signUp(email: email, password: password)
    }
    
    static func fetchPokemonList(offset: Int, limit: Int) -> Observable<(items: [PokemonShort], maxCount: Int)> {
        return shared.networkDataFetcher
            .request(.pokemonList(offset: offset, limit: limit), method: .get)
            .map({ response in
                let pokemonsJSON = response["results"] as? [[String: Any]]
                let pokemons: [PokemonShort] = pokemonsJSON?.decode() ?? []
                let maxCount = response["count"] as? Int ?? pokemons.count
                return (pokemons, maxCount)
            })
    }
    
    static func fetchPokemon(_ pokemon: PokemonShort) -> Observable<PokemonDetail> {
        return shared.networkDataFetcher
            .request(.pokemon(pokemon.id), method: .get)
            .map { response in
                let pokemon: PokemonDetail = try response.decode()
                return pokemon
        }
    }
}

