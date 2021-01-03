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

    @IBOutlet weak var signInButton: UIButton!

    private let appearance = UITabBarAppearance()
    private let tokenLabel = "accessToken"
    private var link: URL?
    private var isAvailable = false

    override func viewDidLoad() {
        super.viewDidLoad()

        appearance.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearance

        checkToken(label: tokenLabel, button: signInButton)
    }

    private func checkToken (label: String, button: UIButton) {
        isAvailable = Keychain.shared.checkKeychain(for: label)

        if isAvailable {
            button.setTitle("Sign out", for: .normal)
        } else {
            button.setTitle("Sign in", for: .normal)
        }
    }

    @IBAction func signInButtonPressed(_ sender: UIButton) {

        if isAvailable {
            sender.setTitle("Sign in", for: .normal)
            Keychain.shared.removeToken(for: tokenLabel)
            isAvailable = Keychain.shared.checkKeychain(for: tokenLabel)
        } else {
            NetworkManager.shared.autorizationFoursquare { (url) in
                self.link = url
            }
            guard let url = link else {
                return
            }

            let safariViewController = SFSafariViewController(url: url)
            safariViewController.delegate = self
            present(safariViewController, animated: true, completion: nil)
        }
    }
}
extension AccountViewController: SFSafariViewControllerDelegate {
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        let code = URL.valueOf("code")

        NetworkManager.shared.getAccessToken(code: code) { (accessToken) in

            guard let accessToken = accessToken else {
                return
            }
            Keychain.shared.saveToken(accessToken: accessToken, for: self.tokenLabel)
            DispatchQueue.main.async {
                self.signInButton.setTitle("Sign out", for: .normal)
            }
            self.isAvailable = Keychain.shared.checkKeychain(for: self.tokenLabel)
        }
    }
}
