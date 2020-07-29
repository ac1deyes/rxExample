//
//  UIStoryboard+ Extentions.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static func authorizationView() -> AuthorizationView {
        return storyboardNamed("Main", viewIdentifier: "AuthorizationView") as! AuthorizationView
    }
    
    static func pokemonListView() -> PokemonListView {
        return storyboardNamed("Main", viewIdentifier: "PokemonListView") as! PokemonListView
    }
    
    static func pokemonView() -> PokemonView {
        return storyboardNamed("Main", viewIdentifier: "PokemonView") as! PokemonView
    }
    
    static func termsOfUseView() -> TermsOfUseView {
        return storyboardNamed("Main", viewIdentifier: "TermsOfUseView") as! TermsOfUseView
    }

    
    static private func storyboardNamed(_ name: String, viewIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewIdentifier)
        return viewController
    }
}
