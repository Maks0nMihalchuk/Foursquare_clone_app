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
}

// MARK: - getStoryboard
private extension SettingsAssembly {

    func getStoruboard() -> UIStoryboard {
        return UIStoryboard(name: "SettingsStoryboard", bundle: nil)
    }
}
