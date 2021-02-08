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
    private let accountRouter: AccountRoutingProtocol

    init(assembly: MainAssemblyProtocol,
         homeRouter: HomeRoutingProtocol,
         accountRouter: AccountRoutingProtocol) {
        self.assembly = assembly
        self.homeRouter = homeRouter
        self.accountRouter = accountRouter
    }

    func showMainStory(_ window: UIWindow?, animated: Bool) {

        let tabBarController = assembly.assemblyTabBarController()
        let homeNavigationController = getHomeViewController()
        let accountNavigationController = getAccountViewController()
        let viewControllers: [UIViewController] = [homeNavigationController,
                                                   accountNavigationController]

        tabBarController.setViewControllers(viewControllers, animated: animated)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

// MARK: - setup TabBarItem
private extension MainRouting {

    func getHomeViewController() -> UIViewController {
        var homeNavigationController: UIViewController = UINavigationController()
        homeRouter.showHomeStory(from: &homeNavigationController, animated: true)
        return homeNavigationController
    }

    func getAccountViewController() -> UIViewController {
        var accountNavigationController: UIViewController = UINavigationController()
        accountRouter.showAccountStory(from: &accountNavigationController, animated: true)
        return accountNavigationController
    }
}
