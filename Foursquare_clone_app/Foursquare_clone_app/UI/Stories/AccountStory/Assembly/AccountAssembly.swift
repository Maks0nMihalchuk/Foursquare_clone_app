//
//  AccountAssembly.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class AccountAssembly: AccountAssemblyProtocol {

    func assemblyAccountViewController() -> ContainerViewController? {
        let controllerID = String(describing: ContainerViewController.self)
        let accountController = getStoryboard()
            .instantiateViewController(withIdentifier: controllerID)
            as? ContainerViewController
        return accountController
    }
}

// MARK: - getStoryboard
private extension AccountAssembly {

    func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "AccountStoryboard", bundle: nil)
    }
}
