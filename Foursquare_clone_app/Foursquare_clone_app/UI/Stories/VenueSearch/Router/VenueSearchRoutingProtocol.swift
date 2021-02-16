//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 31.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

typealias VenueSearchStoryCompletion = ((_ result: VenueSearchStoryResult) -> Void)

protocol VenueSearchRoutingProtocol {
    func showVenueSearchStory(from: UIViewController,
                              model: [Venue],
                              setupSearchBar: (isActiveSearchBar: Bool, searchBarText: String),
                              animated: Bool,
                              completion: @escaping VenueSearchStoryCompletion)
    func hideVenueSearchStory(animated: Bool)
}
