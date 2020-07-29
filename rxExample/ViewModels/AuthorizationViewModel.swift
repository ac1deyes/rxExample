//
//  AuthorizationViewModel.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AuthorizationViewModel {
    
    private let sceneCoordinator: SceneCoordinatorType
    private let disposeBag = DisposeBag()
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
    
    // MARK: - Network
    
    private func signIn(email: String, password: String) -> Observable<User> {
        return PokemonAPI.signIn(email: email, password: password, strategy: FirebaseAuthorizationStratege())
    }
    
    private func signUp(email: String, password: String) -> Observable<User> {
        return PokemonAPI.signUp(email: email, password: password, strategy: FirebaseAuthorizationStratege())
    }
    
    // MARK: - Validation
    
    private func validate(email: String?, password: String?) throws -> Observable<(String, String)> {
        let emailVerify = try ConditionsVerificator(verificator: EmailStrategy()).verify(email)
        let passwordVerify = try ConditionsVerificator(verificator: PasswordStrategy()).verify(password)
        return Observable.combineLatest(emailVerify, passwordVerify)
    }
}

extension AuthorizationViewModel: ViewModelType {
    struct Input {
        let email: Observable<String>
        let password: Observable<String>
        let signIn: Observable<Void>
        let signUp: Observable<Void>
        let termsOfUse: Observable<Void>
    }
    
    struct Output {
        let loading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let signInValidatiton = input.signIn
            .withLatestFrom(Observable.combineLatest(input.email, input.password))
            .flatMap ({ [unowned self] (email, password) in
                return try self.validate(email: email, password: password).materialize()
            })
            .filter ({ [weak self] event in
                switch event {
                case .next(_): return true
                case .completed: return false
                case .error(let error):
                    self?.sceneCoordinator.transition(to: .alert(ErrorValidator.toAlert(error)), type: .alert)
                    return false
                }
            }).share()
        
        let signUpValidatiton = input.signUp
            .withLatestFrom(Observable.combineLatest(input.email, input.password))
            .flatMap ({ [unowned self] (email, password) in
                return try self.validate(email: email, password: password).materialize()
            })
            .filter ({ [weak self] event in
                switch event {
                case .next(_): return true
                case .completed: return false
                case .error(let error):
                    self?.sceneCoordinator.transition(to: .alert(ErrorValidator.toAlert(error)), type: .alert)
                    return false
                }
            }).share()
        
        
        let signIn = signInValidatiton
            .withLatestFrom(Observable.combineLatest(input.email, input.password))
            .flatMap { self.signIn(email: $0.0, password: $0.1).materialize() }
        
        let signUp = signUpValidatiton
            .withLatestFrom(Observable.combineLatest(input.email, input.password))
            .flatMap { self.signUp(email: $0.0, password: $0.1).materialize() }
        
        let response = Observable.merge(signIn, signUp).share()
        
        let success = response
            .compactMap { $0.element }
            .do(onNext: { [weak self] user in
                guard let self = self else { return }
                let viewModel = PokemonListViewModel(coordinator: self.sceneCoordinator)
                self.sceneCoordinator.transition(to: Scene.pokemonList(viewModel), type: .root)
            })
            .map { _ in }
        
        let error = response.compactMap { $0.error }
            .do(onNext: { [weak self] error in
                guard let self = self else { return }
                self.sceneCoordinator.transition(to: .alert(ErrorValidator.toAlert(error)), type: .alert)
            })
            .map { _ in }
        
        let loading = Observable.merge(Observable.merge(signInValidatiton, signUpValidatiton).map { _ in true },
                                               Observable.merge(success, error).map { _ in false })
            .asDriver(onErrorJustReturn: false)
        
        input.termsOfUse
            .bind(onNext: { [unowned self] in
                let viewModel = TermsOfUseViewModel(coordinator: self.sceneCoordinator, url: URLs.termsOfUse)
                self.sceneCoordinator.transition(to: Scene.termsOfUse(viewModel), type: .modal)
            })
            .disposed(by: disposeBag)
        
        return Output(loading: loading)
    }
}
