//
//  ListsRouting.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class ListsRouting: ListsRoutingProtocol {

    private let assembly: ListsAssemblyProtocol

    init(assembly: ListsAssemblyProtocol) {
        self.assembly = assembly
    }

    func showListsStory(from: inout UIViewController, animated: Bool) {
        let listsController = assembly.assemblyListsViewController()

        guard let controller = listsController else { return }

        if from is UINavigationController {

            guard let navigationController = from as? UINavigationController else { return }

            navigationController.viewControllers = [controller]
            controller.navigationController?.navigationBar.isHidden = true
        } else {
            from = controller
        }
    }
}
