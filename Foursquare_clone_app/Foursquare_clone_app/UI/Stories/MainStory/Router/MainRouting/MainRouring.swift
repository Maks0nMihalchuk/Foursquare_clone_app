//
//  TabBarRouring.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class MainRouting: MainRoutingProtocol {

    private let assembly: MainAssemblyProtocol
    private let homeRouter: HomeRoutingProtocol

    init(assembly: MainAssemblyProtocol, homeRouter: HomeRoutingProtocol) {
        self.assembly = assembly
        self.homeRouter = homeRouter
    }

    func showMainStory(_ window: UIWindow?, animated: Bool) {

        let tabBarController = assembly.assemblyTabBarController()
        let homeNavigationController = getHomeViewController()

        tabBarController.setViewControllers([homeNavigationController],
                                            animated: animated)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

private extension MainRouting {

    func getHomeViewController() -> UIViewController {
        var homeNavigationController: UIViewController = UINavigationController()
        homeRouter.showHomeStory(from: &homeNavigationController, animated: true)
        return homeNavigationController
    }
}
