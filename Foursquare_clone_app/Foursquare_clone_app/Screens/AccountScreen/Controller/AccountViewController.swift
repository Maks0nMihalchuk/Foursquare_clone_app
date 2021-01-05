//
//  AccountViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 28.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import UIKit
import SafariServices
import Security

class AccountViewController: UIViewController {

    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var profileLabel: UILabel!
    @IBOutlet private weak var activityIndecator: UIActivityIndicatorView!
    @IBOutlet private weak var updateDataButton: UIButton!

    private let appearance = UITabBarAppearance()
    private let redirectUrl = NetworkManager.shared.redirectUrl.lowercased()
    private let keychainManager = KeychainManager.shared
    private var isAvailable = false

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataButton.alpha = 0
        appearance.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearance
        checkToken(button: signInButton)
    }

    private func checkToken (button: UIButton) {
        let query = keychainManager.tokenRequest(accessToken: nil,
                                                 for: getKeyToToken())
        isAvailable = keychainManager.checkValue(query: query)
        setupActivityIndecator(isHidden: isAvailable, indecator: activityIndecator)
        if isAvailable {
            button.setTitle("Sign out", for: .normal)
            getUserInfo(isAvailableToken: isAvailable)
        } else {
            button.setTitle("Sign in", for: .normal)
            showRefreshButton(button: updateDataButton, isHidden: isAvailable)
        }
    }

    private func setupActivityIndecator (isHidden: Bool, indecator: UIActivityIndicatorView) {
        if isHidden {
            indecator.isHidden = !isHidden
            indecator.startAnimating()
        } else {
            indecator.isHidden = !isHidden
            indecator.stopAnimating()
        }
    }

    private func getKeyToToken () -> String {
        return KeychainKey.accessToken.currentKey
    }

    private func getUserInfo (isAvailableToken: Bool) {
        if isAvailableToken {

            let keyToToken = getKeyToToken()
            let query = keychainManager.tokenRequest(accessToken: nil, for: keyToToken)
            let accessToken = keychainManager.getValue(query: query)
            NetworkManager.shared.getUserInfo(accessToken: accessToken) { (userFullName) in
                guard let userFullName = userFullName else {
                    return
                }
                DispatchQueue.main.async {
                    self.profileLabel.text = userFullName
                    self.setupActivityIndecator(isHidden: !self.isAvailable, indecator: self.activityIndecator)
                    self.showRefreshButton(button: self.updateDataButton, isHidden: self.isAvailable)
                }
            }
        } else {

            profileLabel.text = "Your profile"
        }
    }

    private func showRefreshButton (button: UIButton, isHidden: Bool) {
        UIView.animate(withDuration: 1, delay: 0.0, options: .curveEaseOut, animations: {
            if isHidden {
                button.alpha = 1
            } else {
                button.alpha = 0
            }
        }, completion: nil)
    }

    @IBAction func signInButtonPressed (_ sender: UIButton) {
        if isAvailable {
            let keyToToken = getKeyToToken()
            sender.setTitle("Sign in", for: .normal)
            let query = keychainManager.tokenRequest(accessToken: nil,
                                                            for: keyToToken)

            keychainManager.removeValue(query: query)
            isAvailable = false
            getUserInfo(isAvailableToken: isAvailable)
            showRefreshButton(button: updateDataButton, isHidden: isAvailable)

        } else {
            var link: URL?
            NetworkManager.shared.autorizationFoursquare { (url) in
                link = url
            }
            guard let url = link else {
                return
            }

            let safariViewController = SFSafariViewController(url: url)
            safariViewController.delegate = self
            present(safariViewController, animated: true, completion: nil)
        }
    }

    @IBAction func dataRefreshButtonPressed (_ sender: UIButton) {
        setupActivityIndecator(isHidden: isAvailable, indecator: activityIndecator)
        getUserInfo(isAvailableToken: isAvailable)
    }

}
extension AccountViewController: SFSafariViewControllerDelegate {
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {

        if URL.absoluteString.contains(redirectUrl) {
            dismiss(animated: true, completion: nil)
            setupActivityIndecator(isHidden: !isAvailable, indecator: activityIndecator)

            let code = URL.valueOf("code")

            NetworkManager.shared.getAccessToken(code: code) { (accessToken) in

                guard let accessToken = accessToken?.data(using: .utf8) else {
                    return
                }
                let tokenQuery = self.keychainManager.tokenRequest(accessToken: accessToken, for: self.getKeyToToken())
                self.keychainManager.saveValue(query: tokenQuery)
                self.isAvailable = true
                DispatchQueue.main.async {
                    self.signInButton.setTitle("Sign out", for: .normal)
                    self.getUserInfo(isAvailableToken: self.isAvailable)
                    self.setupActivityIndecator(isHidden: !self.isAvailable, indecator: self.activityIndecator)
                }
            }
        }
    }
}
