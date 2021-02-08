//
//  ListsAssembly.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class ListsAssembly: ListsAssemblyProtocol {

    func assemblyListsViewController() -> ListsViewController? {
        let controllerID = String(describing: ListsViewController.self)
        let listsController = getStorboard()
            .instantiateViewController(withIdentifier: controllerID)
            as? ListsViewController
        return listsController
    }
}

// MARK: - getStoryboard
private extension ListsAssembly {

    func getStorboard() -> UIStoryboard {
        return UIStoryboard(name: "ListsStoryboard", bundle: nil)
    }
}
