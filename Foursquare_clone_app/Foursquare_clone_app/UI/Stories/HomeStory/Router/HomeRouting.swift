//
//  HomeRouter.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class HomeRouting: HomeRoutingProtocol {

    private let assembly: HomeAssembly

    init(assembly: HomeAssembly) {
        self.assembly = assembly
    }

    func showHomeStory(from: inout UIViewController, animated: Bool) {
        let homeController = assembly.assemblyHomeViewController()

        guard let controller = homeController else { return }

        if from is UINavigationController {

            guard let navigationController = from as? UINavigationController else { return }

            navigationController.viewControllers = [controller]
            controller.navigationController?.navigationBar.isHidden = true
        } else {
            from = controller
        }
    }
}
