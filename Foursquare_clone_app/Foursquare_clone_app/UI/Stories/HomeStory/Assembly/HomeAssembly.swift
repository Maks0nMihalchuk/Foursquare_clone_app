//
//  HomeAssembly.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.02.2021.
//  Copyright © 2021 maks. All rights reserved.
// swiftlint:disable force_cast

import Foundation
import UIKit

class HomeAssembly: HomeAssemblyProtocol {

    func assemblyHomeViewController() -> HomeViewController {
        let controllerID = String(describing: HomeViewController.self)
        let homeController = getStoryboard()
            .instantiateViewController(withIdentifier: controllerID)
            as! HomeViewController
        return homeController
    }
}

// MARK: - getStoryboard
private extension HomeAssembly {

    func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "HomeStoryboard", bundle: nil)
    }
}
