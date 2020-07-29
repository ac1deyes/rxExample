//
//  FeedView.swift
//  rxExample
//
//  Created by Vladislav on 06.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import UIKit
import RxSwift

class PokemonView: UIViewController, BindableType {
    
    typealias SectionData = (PokemonTableViewRows, Int)
    
    enum PokemonTableViewRows: String, CaseIterable {
        case baseExperience = "Base Experience"
        case weight = "Weight"
        case height = "Height"
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: PokemonViewModel!
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        title = viewModel.pokemonShort.name
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Bind Data
    
    func bindViewModel() {
        viewModel.loading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.pokemon
            .compactMap ({ pokemon -> [SectionData] in
                return [(.baseExperience, pokemon.baseExperience), (.height, pokemon.height), (.weight, pokemon.height)]
            })
            .bind(to: tableView.rx.items(cellIdentifier: "PokemonCellIdentifier")) { row, model, cell in
                cell.textLabel?.text = model.0.rawValue
                cell.detailTextLabel?.text = String(model.1)
        }.disposed(by: disposeBag)
    }
}


