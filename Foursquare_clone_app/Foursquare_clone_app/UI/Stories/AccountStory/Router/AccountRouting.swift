//
//  AccountRouting.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class AccountRouting: AccountRoutingProtocol {

    private let assembly: AccountAssemblyProtocol

    init(assembly: AccountAssemblyProtocol) {
        self.assembly = assembly
    }

    func showAccountStory(from: inout UIViewController, animated: Bool) {
        let accountController = assembly.assemblyAccountViewController()

        guard let controller = accountController else { return }

        if from is UINavigationController {

            guard let navigationController = from as? UINavigationController else { return }

            navigationController.viewControllers = [controller]
            controller.navigationController?.navigationBar.isHidden = true
        } else {
            from = controller
        }
    }
}
