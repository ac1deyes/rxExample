//
//  PokemonListView.swift
//  rxExample
//
//  Created by Vladislav on 14.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import UIKit
import RxSwift

class PokemonListView: UIViewController, BindableType {    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var footerActivityIndicator: UIActivityIndicatorView!
    
    var viewModel: PokemonListViewModel!
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Bind Data
    
    func bindViewModel() {
        let inputs = PokemonListViewModel.Input(itemWillDisplay: tableView.rx.willDisplayCell.map { $0.indexPath },
                                                itemSelected: tableView.rx.itemSelected.asObservable())
        let outputs = viewModel.transform(input: inputs)
        
        outputs.items.bind(to: tableView.rx.items(cellIdentifier: "PokemonCellIdentifier")) { row, model, cell in
            cell.textLabel?.text = model.name
        }.disposed(by: disposeBag)
        
        outputs.loadingNext
            .bind(to: footerActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        outputs.loading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .bind(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
