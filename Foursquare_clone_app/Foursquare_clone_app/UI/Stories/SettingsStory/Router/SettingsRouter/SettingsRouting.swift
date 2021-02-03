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
}

// MARK: - SettingsViewControllerDelegate
extension SettingsRouting: SettingsViewControllerDelegate {
    func settingsViewController(_ viewController: SettingsViewController,
                                didTapBack button: UIBarButtonItem) {
        finalizeStory()
    }
}
