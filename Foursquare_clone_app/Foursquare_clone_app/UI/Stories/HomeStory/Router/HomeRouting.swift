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

        controller.delegate = self
        controller.title = "HomeViewController.Title".localized()

        if from is UINavigationController {

            guard let navigationController = from as? UINavigationController else { return }

            navigationController.viewControllers = [controller]
            controller.navigationController?.navigationBar.isHidden = true
        } else {
            from = controller
        }
    }
}

// MARK: -
extension HomeRouting: HomeViewControllerDelegate {
    func homeViewController(_ viewController: HomeViewController,
                            didStartedSearchingWith model: [Venue],
                            setupSearchBar: (activateSearchBar: Bool,
                                             searchBarText: String),
                            router: VenueSearchRouting,
                            animated: Bool) {
        router.showVenueSearchStory(from: viewController,
                                    model: model,
                                    setupSearchBar: (isActiveSearchBar: setupSearchBar.activateSearchBar,
                                                     searchBarText: setupSearchBar.searchBarText),
                                    animated: animated) { (_) in
                                        router.hideVenueSearchStory(animated: true)
        }
    }
}
