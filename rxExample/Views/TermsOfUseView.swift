//
//  TermsOfUseView.swift
//  rxExample
//
//  Created by Vladislav on 24.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import UIKit
import WebKit
import Action
import RxSwift
import RxCocoa
import SnapKit

class TermsOfUseView: UIViewController, BindableType {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    var webView: WKWebView!
    
    var viewModel: TermsOfUseViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        load(viewModel.url)
    }

    // MARK: - Setup Views
    
    private func setupViews() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.backgroundColor = .white
        view.insertSubview(webView, belowSubview: progressView)
        webView.snp.makeConstraints { [unowned self] make in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
    
    func load(_ url: URL) {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        webView.load(request)
    }
    
    func bindViewModel() {
        
        closeButton.rx.action = viewModel.onCancel
        
        webView.rx.estimatedProgress
            .map { Float($0) }
            .bind(onNext: { [weak self] progress in
                self?.progressView.setProgress(progress, animated: true)
                if progress >= 1 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self?.progressView.alpha = 0
                    })
                }
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - WKNavigationDelegate

extension TermsOfUseView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        errorLabel.text = .none
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        errorLabel.text = .none
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        errorLabel.text = error.localizedDescription
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        errorLabel.text = .none
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        errorLabel.text = .none
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        errorLabel.text = error.localizedDescription
    }
}
