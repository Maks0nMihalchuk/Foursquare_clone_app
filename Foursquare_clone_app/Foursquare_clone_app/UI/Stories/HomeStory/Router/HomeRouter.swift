//
//  HomeRouter.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class HomeRouter: HomeRouterProtocol {

    private let assembly: HomeAssemblyProtocol
    private let venueSearchRouter: VenueSearchRouterProtocol = VenueSearchRouter(assembly: VenueSearchAssembly())

    init(assembly: HomeAssemblyProtocol) {
        self.assembly = assembly
    }

    func showHomeStory(from: inout UIViewController, animated: Bool) {
        let homeController = assembly.assemblyHomeViewController()

        homeController.delegate = self
        homeController.title = "HomeViewController.Title".localized()

        if from is UINavigationController {

            guard let navigationController = from as? UINavigationController else { return }

            navigationController.viewControllers = [homeController]
            homeController.navigationController?.navigationBar.isHidden = true
        } else {
            from = homeController
        }
    }
}

// MARK: - HomeViewControllerDelegate
extension HomeRouter: HomeViewControllerDelegate {
    func homeViewController(_ viewController: HomeViewController,
                            didStartedSearchingWith model: [Venue],
                            setupSearchBar: (activateSearchBar: Bool,
                                             searchBarText: String),
                            animated: Bool) {
        venueSearchRouter.showVenueSearchStory(from: viewController,
                                    model: model,
                                    setupSearchBar: (isActiveSearchBar: setupSearchBar.activateSearchBar,
                                                     searchBarText: setupSearchBar.searchBarText),
                                    animated: animated) { (_) in
                                        self.venueSearchRouter.hideVenueSearchStory(animated: true)
        }
    }
}
