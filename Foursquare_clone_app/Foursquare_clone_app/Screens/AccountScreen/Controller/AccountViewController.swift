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
    private var link: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        appearance.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearance
    }

    @IBAction func signInButtonPressed(_ sender: UIButton) {

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
extension AccountViewController: SFSafariViewControllerDelegate {
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        let code = URL.valueOf("code")

        NetworkManager.shared.getAccessToken(code: code) { (accessToken) in
        
        }
    }
}
