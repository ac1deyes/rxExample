//
//  PokemonListViewModel.swift
//  rxExample
//
//  Created by Vladislav on 14.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PokemonListViewModel {
    
    private typealias FetchDataResponse = (items: [PokemonShort], maxCount: Int)
    
    private var offset: Int = 0
    private let limit: Int = 50
    private static let itemsLeftBeforeLoadNext: Int = 3
    
    private let sceneCoordinator: SceneCoordinatorType
    private let disposeBag = DisposeBag()
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
    
    // MARK: - Network
    
    private func fetchData(offset: Int, limit: Int) -> Observable<(FetchDataResponse)> {
        return PokemonAPI.fetchPokemonList(offset: offset, limit: limit)
    }
    
    // MARK: - ViewModels
    
    private func pokemonViewModel(_ pokemon: PokemonShort) -> PokemonViewModel {
        return PokemonViewModel(coordinator: sceneCoordinator, pokemon: pokemon)
    }
}

extension PokemonListViewModel: ViewModelType {
    struct Input {
        let itemWillDisplay: Observable<IndexPath>
        let itemSelected: Observable<IndexPath>
    }
    
    struct Output {
        let items: Observable<[PokemonShort]>
        let loading: Observable<Bool>
        let loadingNext: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let items: BehaviorRelay<[PokemonShort]> = BehaviorRelay(value: [])
        let maxItemsCount: BehaviorRelay<Int> = BehaviorRelay(value: limit)
        
        let loadNextTrigger = Observable.combineLatest(input.itemWillDisplay, items, maxItemsCount) { ($0, $1, $2) }
            .filter { $2 > $1.count && $0.row == $1.count - PokemonListViewModel.itemsLeftBeforeLoadNext }
            .map { _ in }
            .share()
        
        let request = fetchData(offset: offset, limit: limit)
            .materialize()
            .share()
        
        let nextRequest = loadNextTrigger
            //            .delay(.seconds(3), scheduler: MainScheduler.instance) // testing tableFooterView animation
            .flatMapFirst { [unowned self] in self.fetchData(offset: self.offset, limit: self.limit) }
            .share()
        
        let loading = request.dematerialize()
            .map { _ in false }
            .share()
        
        let loadingNext = Observable.merge(loadNextTrigger.map { _ in true },
                                           nextRequest.asObservable().map { _ in false }).share()
        
        let requestsResponse: Observable<FetchDataResponse> = Observable.merge(request.dematerialize(),
                                                                               nextRequest.asObservable()).share()
        
        let responsItems: Observable<[PokemonShort]> = requestsResponse.map { $0.items }
            .scan(into: []) { [weak self] (items, new) in
                self?.offset += new.count
                items.append(contentsOf: new)
        }.share()
        
        responsItems.bind(to: items)
        .disposed(by: disposeBag)
        
        
        let responseMaxItemsCount = requestsResponse.map { $0.maxCount }
        responseMaxItemsCount
            .bind(to: maxItemsCount)
            .disposed(by: disposeBag)
        
        input.itemSelected
            .bind(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let pokemon = items.value[indexPath.row]
                let viewModel = self.pokemonViewModel(pokemon)
                self.sceneCoordinator.transition(to: .pokemon(viewModel), type: .push)
            })
            .disposed(by: disposeBag)

        return Output(items: items.asObservable(), loading: loading, loadingNext:loadingNext)
    }
}
