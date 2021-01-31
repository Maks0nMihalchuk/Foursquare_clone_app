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
    var searchController: UIViewController?
    private let assembly: VenueSearchAssembly

    init(assembly: VenueSearchAssembly) {
        self.assembly = assembly
    }

    func showVenueSearchStory(from: UIViewController,
                              model: [Venue],
                              isActiveSearchBar: Bool,
                              searchBarText: String,
                              completion: @escaping VenueSearchStoryCompletion) {
        self.completion = completion

        let searchController = assembly.assemblySearchVC()

        guard let controller = searchController else { return }

        controller.venues = model
        controller.searchBarText = searchBarText
        controller.launchSearchBar = isActiveSearchBar
        controller.modalPresentationStyle = .fullScreen
        from.present(controller, animated: true, completion: nil)
    }

    func hideVenueSearchStory(animated: Bool) {
        guard let conroller = searchController else { return }

        conroller.dismiss(animated: animated, completion: nil)
        searchController = nil
    }

    private func finalizeStory() {
        self.completion?(.userCancelation)
        completion = nil
    }
}

// MARK: - SearchViewControllerDelegate
