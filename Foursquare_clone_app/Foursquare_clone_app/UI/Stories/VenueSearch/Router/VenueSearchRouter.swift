//
//  VenueSearchRouting.swift
//  Foursquare_clone_app
//
//  Created by maks on 31.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

enum VenueSearchStoryResult {
    case success
    case userCancelation
    case failure(error: Error?)
}

class VenueSearchRouter: VenueSearchRouterProtocol {

    private var completion: VenueSearchStoryCompletion?
    private var searchController: SearchViewController?
    private let assembly: VenueSearchAssemblyProtocol
    private let venueDetailRouter: VenueDetailsRouterProtocol = VenueDetailsRouter(assembly: VenueDetailsAssembly(),
                                                                                   networking: NetworkManager.shared)

    init(assembly: VenueSearchAssemblyProtocol) {
        self.assembly = assembly
    }

    func showVenueSearchStory(from: UIViewController,
                              model: [Venue],
                              setupSearchBar: (isActiveSearchBar: Bool, searchBarText: String),
                              animated: Bool,
                              completion: @escaping VenueSearchStoryCompletion) {
        self.completion = completion

        let searchController = assembly.assemblySearchVC()

        searchController.delegate = self
        searchController.venues = model
        searchController.searchBarText = setupSearchBar.searchBarText
        searchController.launchSearchBar = setupSearchBar.isActiveSearchBar
        self.searchController = searchController
        searchController.modalPresentationStyle = .fullScreen
        from.present(searchController, animated: animated, completion: nil)
    }

    func hideVenueSearchStory(animated: Bool) {
        guard let conroller = searchController else { return }

        conroller.dismiss(animated: animated, completion: nil)

        searchController = nil
    }
}

// MARK: - SearchViewControllerDelegate
extension VenueSearchRouter: SearchViewControllerDelegate {

    func searchViewController(_ viewController: SearchViewController,
                              didTapBack button: UIButton) {
        finalizeStory()
    }

    func searchViewController(_ viewController: SearchViewController,
                              didTapOnRowAt indexPath: IndexPath,
                              venueID: String) {
        showAlertForSelection(viewController, venueID: venueID)
    }
}

private extension VenueSearchRouter {

    private func finalizeStory() {
        self.completion?(.userCancelation)
        completion = nil
    }

    private func showAlertForSelection(_ viewController: SearchViewController,
                                       venueID: String) {
        let title = "AlertSelectController.Title".localized()
        let message = "AlertSelectController.Message".localized()
        let detailWithScrollViewTitle = "detailWithScrollView"
        let detailWithTableViewTitle = "detailWithTableView"
        let cancelButtonTitle = "AlertSelectController.CancelButton".localized()
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .actionSheet)
        let detailWithScrollView = UIAlertAction(title: detailWithScrollViewTitle,
                                                 style: .default) { (_) in
                                                    self.showDetailViewController(viewController,
                                                                                  by: .scrollView,
                                                                                  venueID: venueID)
        }
        let detailWithTableView = UIAlertAction(title: detailWithTableViewTitle,
                                                 style: .default) { (_) in
                                                    self.showDetailViewController(viewController,
                                                                                  by: .tableView,
                                                                                  venueID: venueID)
        }
        let cancelButton = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        alertController.addAction(detailWithScrollView)
        alertController.addAction(detailWithTableView)
        alertController.addAction(cancelButton)
        viewController.present(alertController, animated: true, completion: nil)
    }

    func showDetailViewController(_ viewController: SearchViewController,
                                  by storyType: VenueDetailsStoryType,
                                  venueID: String) {
        venueDetailRouter.showVenueDetailsStory(from: viewController,
                                                type: storyType,
                                                venueID: venueID,
                                                animated: true) { (_) in
                                                    self.venueDetailRouter.hideVenueDetailsStory(animated: true)
        }
    }
}
