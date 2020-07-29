//
//  Scene+ViewController.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import UIKit

extension Scene {
    func viewController() -> UIViewController {
        switch self {
        case .authorization(let viewModel):
            var vc = UIStoryboard.authorizationView()
            vc.bindViewModel(to: viewModel)
            return vc
        case .pokemonList(let viewModel):
            var vc = UIStoryboard.pokemonListView()
            vc.bindViewModel(to: viewModel)
            let nc = UINavigationController(rootViewController: vc)
            return nc
        case .pokemon(let viewModel):
            var vc = UIStoryboard.pokemonView()
            vc.bindViewModel(to: viewModel)
            return vc
        case .termsOfUse(let viewModel):
            var vc = UIStoryboard.termsOfUseView()
            vc.bindViewModel(to: viewModel)
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            return nc
        case .alert(let alert):
            let alertVC = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
            alert.actions?.forEach({ (value) in
                let action = UIAlertAction(title: value.title, style: value.style, handler: value.action)
                alertVC.addAction(action)
            })
            return alertVC
        }
            
    }
}
