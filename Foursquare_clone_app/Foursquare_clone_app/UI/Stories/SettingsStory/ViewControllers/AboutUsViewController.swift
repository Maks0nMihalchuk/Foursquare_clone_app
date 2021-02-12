//
//  AboutUsViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit
import WebKit

protocol AboutUsViewControllerDelegate: class {
    func aboutUsViewController(_ viewController: AboutUsViewController,
                               didTapBack button: UIBarButtonItem)
}

class AboutUsViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private lazy var backButton: UIBarButtonItem = {
        let image = UIImage(named: "backWhiteArrow")
        let button = UIBarButtonItem(image: image, style: .plain, target: self,
                                     action: #selector(screenCloseButtonPressed(_:)))
        button.tintColor = .white
        return button
    }()

    var urlString = String()
    weak var delegate: AboutUsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupWebView()
        setupUI()
    }
}

// MARK: - WKNavigationDelegate
extension AboutUsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}

// MARK: - Setup UI
private extension AboutUsViewController {

    func setupWebView() {
        webView.navigationDelegate = self
    }

    func setupUI() {
        guard let url = getURL() else { return }

        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }

    func getURL() -> URL? {
        let url = URL(string: urlString)
        return url
    }

    func setupNavigationBar() {
        let navBar = navigationController?.navigationBar
        title = "Settings.AboutUs".localized()
        navigationItem.leftBarButtonItem = backButton
        navBar?.barTintColor = .systemBlue
        navBar?.backgroundColor = .systemBlue
        navBar?.barTintColor = .systemBlue
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white,
                                       .font: UIFont.boldSystemFont(ofSize: 22)]
    }

    @objc func screenCloseButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.aboutUsViewController(self, didTapBack: sender)
    }
}
