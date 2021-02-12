//
//  SettingsRouter.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

enum SettingsStoryResult {
    case success
    case userCancelation
    case failure(error: Error?)
}

class SettingsRouter: SettingsRouterProtocol {

    private var completion: SettingsStoryCompletion?
    private var settingsController: SettingsViewController?
    private let assembly: SettingsAssemblyProtocol

    init(assembly: SettingsAssemblyProtocol) {
        self.assembly = assembly
    }

    func showSettingsStory(from: UIViewController,
                           animated: Bool,
                           completion: @escaping SettingsStoryCompletion) {
        self.completion = completion
        let settingsController = assembly.assemblySettingsViewController()

        let navigationController = UINavigationController(rootViewController: settingsController)
        self.settingsController = settingsController
        settingsController.delegate = self
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
extension SettingsRouter: SettingsViewControllerDelegate {

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
        let aboutUsController = assembly.assemblyAboutUsViewController()

        aboutUsController.urlString = urlString
        aboutUsController.delegate = self
        viewController.navigationController?
            .pushViewController(aboutUsController, animated: true)
    }

    func settingsViewController(_ viewController: SettingsViewController,
                                didTapTermsOfUse button: UIButton,
                                with fileName: String) {
        let termsOfUseController = assembly.assemblyTermsOfUseViewController()

        termsOfUseController.fileName = fileName
        termsOfUseController.delegate = self
        viewController.navigationController?
            .pushViewController(termsOfUseController, animated: true)
    }

    func settingsViewController(_ viewController: SettingsViewController,
                                didTapPrivacy button: UIButton) {
        let privacyController = assembly.assemblyPrivacyViewController()

        privacyController.delegate = self
        viewController.navigationController?
            .pushViewController(privacyController, animated: true)
    }
}

// MARK: - AboutUsViewControllerDelegate
extension SettingsRouter: AboutUsViewControllerDelegate {
    func aboutUsViewController(_ viewController: AboutUsViewController,
                               didTapBack button: UIBarButtonItem) {
        viewController.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TermsOfUseViewControllerDelegate
extension SettingsRouter: TermsOfUseViewControllerDelegate {
    func termsOfUseViewController(_ viewController: TermsOfUseViewController,
                                  didTapBack button: UIBarButtonItem) {
        viewController.navigationController?.popViewController(animated: true)
    }
}

// MARK: - PrivacyViewControllerDelegate
extension SettingsRouter: PrivacyViewControllerDelegate {
    func privacyViewController(_ viewController: PrivacyViewController,
                               didTapBack button: UIBarButtonItem) {
        viewController.navigationController?.popViewController(animated: true)
    }
}
