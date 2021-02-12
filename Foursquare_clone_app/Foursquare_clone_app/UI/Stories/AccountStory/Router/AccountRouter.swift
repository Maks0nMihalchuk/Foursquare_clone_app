//
//  AccountRouting.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import SafariServices
import UIKit

class AccountRouter: AccountRouterProtocol {

    private let assembly: AccountAssemblyProtocol
    private let settingsRouter: SettingsRouterProtocol = SettingsRouter(assembly: SettingsAssembly())

    init(assembly: AccountAssemblyProtocol) {
        self.assembly = assembly
    }

    func showAccountStory(from: inout UIViewController, animated: Bool) {
        let accountController = assembly.assemblyAccountViewController()

        accountController.delegate = self
        accountController.title = "AccountViewController.Title".localized()
        if from is UINavigationController {

            guard let navigationController = from as? UINavigationController else { return }

            navigationController.viewControllers = [accountController]
            accountController.navigationController?.navigationBar.isHidden = true
        } else {
            from = accountController
        }
    }
}

// MARK: - AccountViewControllerDelegate
extension AccountRouter: AccountViewControllerDelegate {

    func accountViewController(_ viewController: AccountViewController,
                               didTapSignInButton button: UIButton) {
        NetworkManager.shared.autorizationFoursquare { (url, isSuccessful) in
            if isSuccessful {
                guard let url = url else { return }

                DispatchQueue.main.async {
                    let safariViewController = SFSafariViewController(url: url)
                    safariViewController.delegate = viewController
                    viewController.present(safariViewController, animated: true, completion: nil)
                }
            } else {
                viewController.showErrorAlert()
            }
        }
    }

    func accountViewController(_ viewController: AccountViewController,
                               didTapSignOutButton button: UIButton) {
        let key = Keys.accessToken.stringValue
        KeychainManager.shared.removeValue(for: key)
    }

    func accountViewController(_ viewController: AccountViewController,
                               didTapSettingsButton button: UIButton) {
        settingsRouter.showSettingsStory(from: viewController, animated: true) { (_) in
            self.settingsRouter.hideSettingsStory(animated: true)
        }
    }
}
