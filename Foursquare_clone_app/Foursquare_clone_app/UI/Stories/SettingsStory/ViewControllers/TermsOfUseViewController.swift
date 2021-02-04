//
//  TermsOfUseViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit
import WebKit

protocol TermsOfUseViewControllerDelegate: class {
    func termsOfUseViewController(_ viewController: TermsOfUseViewController,
                                  didTapBack button: UIBarButtonItem)
}

class TermsOfUseViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    var fileName = String()
    private lazy var backButton: UIBarButtonItem = {
        let image = UIImage(named: "backWhiteArrow")
        let button = UIBarButtonItem(image: image, style: .plain, target: self,
                                     action: #selector(screenCloseButtonPressed(_:)))
        button.tintColor = .white
        return button
    }()

    weak var delegate: TermsOfUseViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupWebView()
        setupUI()
    }
}

// MARK: - WKNavigationDelegate
extension TermsOfUseViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}

// MARK: - setup UI
private extension TermsOfUseViewController {

    func setupWebView() {
        webView.navigationDelegate = self
    }

    func setupUI() {
        guard let urlFilePath  = getFilePath() else { return }

        let urlRequest = URLRequest(url: urlFilePath)
        webView.load(urlRequest)
    }

    func getFilePath() -> URL? {
        let fileExtension = ".pdf"
        let filePath = Bundle.main.url(forResource: fileName,
                                       withExtension: fileExtension)
        return filePath
    }

    func setupNavigationBar() {
        let navBar = navigationController?.navigationBar
        title = "Settings.TermsOfUse".localized()
        navigationItem.leftBarButtonItem = backButton
        navBar?.barTintColor = .systemBlue
        navBar?.backgroundColor = .systemBlue
        navBar?.barTintColor = .systemBlue
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white,
                                       .font: UIFont.boldSystemFont(ofSize: 22)]
    }

    @objc func screenCloseButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.termsOfUseViewController(self, didTapBack: sender)
    }
}
