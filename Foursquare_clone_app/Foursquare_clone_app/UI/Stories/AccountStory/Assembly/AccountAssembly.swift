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

    func assemblyAccountViewController() -> AccountViewController? {
        let controllerID = String(describing: AccountViewController.self)
        let accountController = getStoryboard()
            .instantiateViewController(withIdentifier: controllerID)
            as? AccountViewController
        return accountController
    }
}

// MARK: - getStoryboard
private extension AccountAssembly {

    func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "AccountStoryboard", bundle: nil)
    }
}
