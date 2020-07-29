//
//  AuthorizationView.swift
//  rxExample
//
//  Created by Vladislav on 04.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import UIKit
import RxSwift
import RxKeyboard
import RxGesture

class AuthorizationView: UIViewController, BindableType {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var termsOfUseButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var contentBackgroundView: UIView!
    
    @IBOutlet weak var stackViewHorizontalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentBackgroundViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentBackgroundViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: AuthorizationViewModel!
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        stackViewHorizontalCenterConstraint.constant = UIScreen.main.bounds.size.height/2
    }
    
    // MARK: - Bind Data
    
    func bindViewModel() {
        bindGestureRecognizers()
        bindKeyboard()
        
        let inputs = AuthorizationViewModel.Input(email: emailTextField.rx.text.orEmpty.asObservable(),
                                                  password: passwordTextField.rx.text.orEmpty.asObservable(),
                                                  signIn: signInButton.rx.tap.asObservable(),
                                                  signUp: signUpButton.rx.tap.asObservable(),
                                                  termsOfUse: termsOfUseButton.rx.tap.asObservable())
        let outputs = viewModel.transform(input: inputs)
        
        outputs.loading
            .drive(onNext: { [weak self] value in
                guard let self = self else { return }
                if value {
                    self.restrictUserInteractionAccess()
                } else {
                    self.restoreUserInteractionAccess()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindGestureRecognizers() {
        view.rx
            .tapGesture()
            .when(.recognized)
            .filter({ [weak self] tap -> Bool in
                guard let self = self else { return false }
                let textFields = [self.emailTextField!, self.passwordTextField!]
                let frames = textFields.compactMap { $0.superview!.convert($0.frame, to: self.view) }
                let location = tap.location(in: tap.view)
                for frame in frames { if frame.contains(location) { return false } }
                return true
            })
            .subscribe(onNext: { [unowned self] _ in self.view.endEditing(true) })
            .disposed(by: disposeBag)
    }
    
    private func bindKeyboard() {
        RxKeyboard.instance
            .frame
            .skip(1)
            .drive(onNext: { [weak self] frame in
                guard let self = self else { return }
                let dif = UIScreen.main.bounds.size.height - (UIScreen.main.bounds.size.height - frame.origin.y)
                self.stackViewHorizontalCenterConstraint.constant = (dif)/2
                self.view.layoutAnimated(duration: 0.3)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Animations
    
    private func restrictUserInteractionAccess() {
        view.endEditing(true)
        emailTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
        signInButton.isUserInteractionEnabled = false
        signUpButton.isUserInteractionEnabled = false
        termsOfUseButton.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.2) {
            self.signInButton.alpha = 0
            self.signUpButton.alpha = 0
            self.emailTextField.alpha = 0
            self.passwordTextField.alpha = 0
            self.activityIndicator.alpha = 1
            self.termsOfUseButton.alpha = 0
        }
        
        guard let secondView = contentBackgroundViewWidthConstraint.secondItem as? UIView else { return }
        let widthDif = secondView.frame.size.width - 60
        contentBackgroundViewWidthConstraint.constant = -widthDif
        let heightDif = secondView.frame.size.height - 60
        contentBackgroundViewHeightConstraint.constant = -heightDif
        self.view.layoutAnimated(duration: 0.2, delay: 0.1)
        
        activityIndicator.startAnimating()
    }
    
    private func restoreUserInteractionAccess() {
        emailTextField.isUserInteractionEnabled = true
        passwordTextField.isUserInteractionEnabled = true
        signInButton.isUserInteractionEnabled = true
        signUpButton.isUserInteractionEnabled = true
        termsOfUseButton.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.3, delay: 0.15, options: [], animations: {
            self.signInButton.alpha = 1
            self.signUpButton.alpha = 1
            self.emailTextField.alpha = 1
            self.passwordTextField.alpha = 1
            self.activityIndicator.alpha = 0
            self.termsOfUseButton.alpha = 1
        })
        
        contentBackgroundViewWidthConstraint.constant = 26
        contentBackgroundViewHeightConstraint.constant = 26
        self.view.layoutAnimated(duration: 0.2)
        
        activityIndicator.stopAnimating()
    }
    
}
