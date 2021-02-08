//
//  SettingsAssembly.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class SettingsAssembly: SettingsAssemblyProtocol {
    func assemblySettingsVC() -> SettingsViewController? {
        let controllerID = String(describing: SettingsViewController.self)
        let settingsController = getStoruboard()
            .instantiateViewController(withIdentifier: controllerID)
            as? SettingsViewController
        return settingsController
    }

    func assemblyAboutUsVC() -> AboutUsViewController? {
        let controllerID = String(describing: AboutUsViewController.self)
        let aboutUsController = getStoruboard()
            .instantiateViewController(withIdentifier: controllerID)
            as? AboutUsViewController
        return aboutUsController
    }

    func assemblyTermsOfUseViewController() -> TermsOfUseViewController? {
        let controllerID = String(describing: TermsOfUseViewController.self)
        let termsOfUseController = getStoruboard()
        .instantiateViewController(withIdentifier: controllerID)
        as? TermsOfUseViewController
        return termsOfUseController
    }

    func assemblyPrivacyVC() -> PrivacyViewController? {
        let controllerID = String(describing: PrivacyViewController.self)
        let privacyController = getStoruboard()
            .instantiateViewController(withIdentifier: controllerID)
            as? PrivacyViewController
        return privacyController
    }
}

// MARK: - getStoryboard
private extension SettingsAssembly {

    func getStoruboard() -> UIStoryboard {
        return UIStoryboard(name: "SettingsStoryboard", bundle: nil)
    }
}
