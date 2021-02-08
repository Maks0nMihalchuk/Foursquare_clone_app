//
//  VenueSearchRouting.swift
//  Foursquare_clone_app
//
//  Created by maks on 31.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class VenueSearchRouting: VenueSearchRoutingProtocol {

    var completion: VenueSearchStoryCompletion?
    private var searchController: SearchViewController?
    private let assembly: VenueSearchAssembly

    init(assembly: VenueSearchAssembly) {
        self.assembly = assembly
    }

    func showVenueSearchStory(from: UIViewController,
                              model: [Venue],
                              setupSearchBar: (isActiveSearchBar: Bool, searchBarText: String),
                              animated: Bool,
                              completion: @escaping VenueSearchStoryCompletion) {
        self.completion = completion

        let searchController = assembly.assemblySearchVC()

        guard let controller = searchController else { return }

        controller.router = VenueDetailsRouting(assembly: VenueDetailsAssembly(),
                                                networking: NetworkManager.shared)
        controller.delegate = self
        controller.venues = model
        controller.searchBarText = setupSearchBar.searchBarText
        controller.launchSearchBar = setupSearchBar.isActiveSearchBar
        self.searchController = controller
        controller.modalPresentationStyle = .fullScreen
        from.present(controller, animated: animated, completion: nil)
    }

    func hideVenueSearchStory(animated: Bool) {
        guard let conroller = searchController else { return }

        conroller.dismiss(animated: animated, completion: nil)
        searchController?.router = nil
        searchController = nil
    }

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
                                                    viewController.showDetailViewController(by: .scrollView,
                                                                                            venueID: venueID)
        }
        let detailWithTableView = UIAlertAction(title: detailWithTableViewTitle,
                                                 style: .default) { (_) in
                                                    viewController.showDetailViewController(by: .tableView,
                                                                                            venueID: venueID)
        }
        let cancelButton = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        alertController.addAction(detailWithScrollView)
        alertController.addAction(detailWithTableView)
        alertController.addAction(cancelButton)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - SearchViewControllerDelegate
extension VenueSearchRouting: SearchViewControllerDelegate {

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
