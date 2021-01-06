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
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var updateDataButton: UIButton!

    private let appearance = UITabBarAppearance()
    private let redirectUrl = NetworkManager.shared.redirectUrl.lowercased()
    private let keychainManager = KeychainManager.shared
    private var isAvailable = false

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataButton.setTitle("AccountViewController.UpdateDataButton".localized(), for: .normal)
        setupView(updateButton: updateDataButton, appearance: appearance)

        checkToken(button: signInButton)
    }

    private func setupView (updateButton: UIButton, appearance: UITabBarAppearance) {
        updateButton.alpha = 0
        appearance.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearance
    }

    private func checkToken (button: UIButton) {
        isAvailable = keychainManager.checkForDataAvailability(for: getKeyToToken())
        setupActivityIndicator(isHidden: isAvailable, indecator: activityIndicator)

        if isAvailable {
            button.setTitle("AccountViewController.SignOutButton".localized(), for: .normal)
            getUserInfo(isAvailableToken: isAvailable)
        } else {
            button.setTitle("AccountViewController.SignInButton".localized(), for: .normal)
            showRefreshButton(button: updateDataButton, isHidden: isAvailable)
        }
    }

    private func setupActivityIndicator (isHidden: Bool, indecator: UIActivityIndicatorView) {
        indecator.isHidden = !isHidden

        if isHidden {
            indecator.startAnimating()
        } else {
            indecator.stopAnimating()
        }
    }

    private func getKeyToToken () -> String {
        return KeychainKey.accessToken.currentKey
    }

    private func getUserInfo (isAvailableToken: Bool) {

        if isAvailableToken {
            let accessToken = keychainManager.getValue(for: getKeyToToken())
            NetworkManager.shared.getUserInfo(accessToken: accessToken) { (userFullName, isSuccessful) in

                if isSuccessful {

                    guard let userFullName = userFullName else {
                        return
                    }

                    DispatchQueue.main.async {
                        self.profileLabel.text = userFullName
                        self.setupActivityIndicator(isHidden: !self.isAvailable,
                                                    indecator: self.activityIndicator)
                        self.showRefreshButton(button: self.updateDataButton, isHidden: self.isAvailable)
                    }
                } else {
                    self.setupActivityIndicator(isHidden: !self.isAvailable, indecator: self.activityIndicator)
                }
            }
        } else {
            profileLabel.text = "AccountViewController.YourProfile".localized()
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

    private func showErrorAlert () {
        let alertController = UIAlertController(title: "AccountViewController.AlertTitle".localized(),
                                                message: "AccountViewController.AlertMessage".localized(),
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "AccountViewController.AlertActionTitle".localized(),
                                   style: .default,
                                   handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func signInButtonPressed (_ sender: UIButton) {

        if isAvailable {
            sender.setTitle("AccountViewController.SignInButton".localized(), for: .normal)

            keychainManager.removeValue(for: getKeyToToken())
            isAvailable = false
            getUserInfo(isAvailableToken: isAvailable)
            showRefreshButton(button: updateDataButton, isHidden: isAvailable)
        } else {
            NetworkManager.shared.autorizationFoursquare { (url) in

                guard let url = url else {
                    return
                }

                DispatchQueue.main.async {
                    let safariViewController = SFSafariViewController(url: url)
                    safariViewController.delegate = self
                    self.present(safariViewController, animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func dataRefreshButtonPressed (_ sender: UIButton) {
        setupActivityIndicator(isHidden: isAvailable, indecator: activityIndicator)
        getUserInfo(isAvailableToken: isAvailable)
    }

}
extension AccountViewController: SFSafariViewControllerDelegate {
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {

        if URL.absoluteString.contains(redirectUrl) {
            dismiss(animated: true, completion: nil)
            setupActivityIndicator(isHidden: !isAvailable, indecator: activityIndicator)

            let code = URL.valueOf("code")

            NetworkManager.shared.getAccessToken(code: code) { (accessToken, isSuccessful) in
                if isSuccessful {
                    let accessToken = accessToken?.data(using: .utf8)

                    DispatchQueue.main.async {

                        if self.keychainManager.saveValue(value: accessToken, with: self.getKeyToToken()) {
                            self.isAvailable = true
                            self.signInButton.setTitle("AccountViewController.SignOutButton".localized(), for: .normal)
                            self.getUserInfo(isAvailableToken: self.isAvailable)
                            self.setupActivityIndicator(isHidden: !self.isAvailable, indecator: self.activityIndicator)
                        } else {
                            self.setupActivityIndicator(isHidden: self.isAvailable, indecator: self.activityIndicator)
                            self.showErrorAlert()
                        }
                    }

                } else {
                    self.setupActivityIndicator(isHidden: self.isAvailable, indecator: self.activityIndicator)
                    self.showErrorAlert()
                }
            }
        }
    }
}
