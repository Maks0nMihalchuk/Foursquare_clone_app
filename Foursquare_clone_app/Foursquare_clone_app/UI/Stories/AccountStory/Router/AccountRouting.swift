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

class AccountRouting: AccountRoutingProtocol {

    private let assembly: AccountAssemblyProtocol

    init(assembly: AccountAssemblyProtocol) {
        self.assembly = assembly
    }

    func showAccountStory(from: inout UIViewController, animated: Bool) {
        let accountController = assembly.assemblyAccountViewController()

        guard let controller = accountController else { return }

        controller.delegate = self

        if from is UINavigationController {

            guard let navigationController = from as? UINavigationController else { return }

            navigationController.viewControllers = [controller]
            controller.navigationController?.navigationBar.isHidden = true
        } else {
            from = controller
        }
    }
}

// MARK: -
extension AccountRouting: AccountViewControllerDelegate {

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
        let key = KeychainKey.accessToken.currentKey
        KeychainManager.shared.removeValue(for: key)
    }

    func accountViewController(_ viewController: AccountViewController,
                               didTapSettingsButton button: UIButton,
                               router: SettingsRouting) {
        router.showSettingsStory(from: viewController, animated: true) { (_) in
            router.hideSettingsStory(animated: true)
        }
    }
}
