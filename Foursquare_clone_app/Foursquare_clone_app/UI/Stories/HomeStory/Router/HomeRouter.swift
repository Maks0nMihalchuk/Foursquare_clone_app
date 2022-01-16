//
//  HomeRouter.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class HomeRouter: HomeRoutingProtocol {

    private let assembly: HomeAssemblyProtocol
    private let venueSearchRouter: VenueSearchRoutingProtocol = VenueSearchRouter(assembly: VenueSearchAssembly())

    init(assembly: HomeAssemblyProtocol) {
        self.assembly = assembly
    }

    func showHomeStory(from: inout UIViewController, animated: Bool) {
        let homeController = assembly.assemblyHomeViewController()

        homeController.delegate = self

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

    func homeViewController(_ viewController: HomeViewController,
                            didShowLocationErrorAlert error: GeopositionObservingError) {
        showLocationErrorAlert(viewController: viewController)
    }
}

// MARK: - setup and display the location Error alert
private extension HomeRouter {

    func showLocationErrorAlert(viewController: HomeViewController) {
        let title = "LocationErrorAlert.Title".localized(name: "HomeVCLocalization")
        let message = "LocationErrorAlert.Message".localized(name: "HomeVCLocalization")
        let buttonTitle = "LocationErrorAlert.Action".localized(name: "HomeVCLocalization")

        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okeyButton = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertController.addAction(okeyButton)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
