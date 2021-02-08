//
//  SettingsRouter.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class SettingsRouting: SettingsRoutingProtocol {

    init(assembly: SettingsAssembly) {
        self.assembly = assembly
    }

    private var completion: SettingsStoryCompletion?
    private var settingsController: SettingsViewController?
    private let assembly: SettingsAssembly

    func showSettingsStory(from: UIViewController,
                           animated: Bool,
                           completion: @escaping SettingsStoryCompletion) {
        self.completion = completion
        let settingsController = assembly.assemblySettingsVC()

        guard let controller = settingsController else { return }

        let navigationController = UINavigationController(rootViewController: controller)
        self.settingsController = controller
        controller.delegate = self
        navigationController.modalPresentationStyle = .fullScreen
        from.present(navigationController, animated: animated, completion: nil)
    }

    func hideSettingsStory(animated: Bool) {
        guard let controller = settingsController else { return }

        controller.dismiss(animated: animated, completion: nil)
        settingsController = nil
    }

    private func finalizeStory() {
        self.completion?(.userCancelation)
        completion = nil
    }

    private func setupNotificationAlert(_ viewController: UIViewController) {
        let alertConrtoller = UIAlertController(title: "Notification",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let setNotificationAction = UIAlertAction(title: "Set", style: .default) { (_) in
            NotificationManager.setNotification(5,
                                                of: .seconds,
                                                repeats: false,
                                                notificationOptions: (title: "Hello",
                                                                      body: "Notification"),
                                                userInfo: ["aps": ["Hello": "world"]])
        }
        let removeNotificationAction = UIAlertAction(title: "Remove", style: .default) { (_) in
            NotificationManager.cancel()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertConrtoller.addAction(setNotificationAction)
        alertConrtoller.addAction(removeNotificationAction)
        alertConrtoller.addAction(cancelAction)
        viewController.present(alertConrtoller, animated: true, completion: nil)
    }
}

// MARK: - SettingsViewControllerDelegate
extension SettingsRouting: SettingsViewControllerDelegate {

    func settingsViewController(_ viewController: SettingsViewController,
                                didChangeValue sender: UISwitch) {
        if sender.isOn {
            setupNotificationAlert(viewController)
        }
    }

    func settingsViewController(_ viewController: SettingsViewController,
                                didTapBack button: UIBarButtonItem) {
        finalizeStory()
    }

    func settingsViewController(_ viewController: SettingsViewController,
                                didTapAboutUs button: UIButton,
                                with urlString: String) {
        let aboutUsController = assembly.assemblyAboutUsVC()

        guard let controller = aboutUsController else { return }

        controller.urlString = urlString
        controller.delegate = self
        viewController.navigationController?
            .pushViewController(controller, animated: true)
    }

    func settingsViewController(_ viewController: SettingsViewController,
                                didTapTermsOfUse button: UIButton,
                                with fileName: String) {
        let termsOfUseController = assembly.assemblyTermsOfUseViewController()

        guard let controller = termsOfUseController else { return }

        controller.fileName = fileName
        controller.delegate = self
        viewController.navigationController?
            .pushViewController(controller, animated: true)
    }

    func settingsViewController(_ viewController: SettingsViewController,
                                didTapPrivacy button: UIButton) {
        let privacyController = assembly.assemblyPrivacyVC()

        guard let controller = privacyController else { return }

        controller.delegate = self
        viewController.navigationController?
            .pushViewController(controller, animated: true)
    }
}

// MARK: - AboutUsViewControllerDelegate
extension SettingsRouting: AboutUsViewControllerDelegate {
    func aboutUsViewController(_ viewController: AboutUsViewController,
                               didTapBack button: UIBarButtonItem) {
        viewController.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TermsOfUseViewControllerDelegate
extension SettingsRouting: TermsOfUseViewControllerDelegate {
    func termsOfUseViewController(_ viewController: TermsOfUseViewController,
                                  didTapBack button: UIBarButtonItem) {
        viewController.navigationController?.popViewController(animated: true)
    }
}

// MARK: - PrivacyViewControllerDelegate
extension SettingsRouting: PrivacyViewControllerDelegate {
    func privacyViewController(_ viewController: PrivacyViewController,
                               didTapBack button: UIBarButtonItem) {
        viewController.navigationController?.popViewController(animated: true)
    }
}
