//
//  TabBarRouring.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class MainRouter: MainRouterProtocol {

    private let assembly: MainAssemblyProtocol
    private let homeRouter: HomeRouterProtocol
    private let accountRouter: AccountRouterProtocol
    private let listsRouter: ListsRouterProtocol

    init(assembly: MainAssemblyProtocol,
         homeRouter: HomeRouterProtocol,
         accountRouter: AccountRouterProtocol,
         listsRouter: ListsRouterProtocol) {
        self.assembly = assembly
        self.homeRouter = homeRouter
        self.accountRouter = accountRouter
        self.listsRouter = listsRouter
    }

    func showMainStory(_ viewController: UIViewController, animated: Bool) {

        let tabBarController = assembly.assemblyTabBarController()
        let homeNavigationController = getHomeViewController()
        let listsNavigationController = getListsViewController()
        let accountNavigationController = getAccountViewController()
        let viewControllers: [UIViewController] = [homeNavigationController,
                                                   listsNavigationController,
                                                   accountNavigationController]

        tabBarController.setViewControllers(viewControllers, animated: animated)

        if viewController is UINavigationController {
            guard let navigationController = viewController as? UINavigationController else { return }

            navigationController.viewControllers = [tabBarController]
            navigationController.navigationBar.isHidden = true
        }
    }
}

// MARK: - setup TabBarItem
private extension MainRouter {

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

    func getListsViewController() -> UIViewController {
        var listsNavigationController: UIViewController = UINavigationController()
        listsRouter.showListsStory(from: &listsNavigationController, animated: true)
        return listsNavigationController
    }
}
