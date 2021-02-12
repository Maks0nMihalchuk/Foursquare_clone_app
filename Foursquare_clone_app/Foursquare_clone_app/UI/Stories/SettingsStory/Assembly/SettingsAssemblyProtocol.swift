//
//  SettingsAssemblyProtocol.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsAssemblyProtocol {
    func assemblySettingsViewController() -> SettingsViewController
    func assemblyAboutUsViewController() -> AboutUsViewController
    func assemblyTermsOfUseViewController() -> TermsOfUseViewController
    func assemblyPrivacyViewController() -> PrivacyViewController
}
