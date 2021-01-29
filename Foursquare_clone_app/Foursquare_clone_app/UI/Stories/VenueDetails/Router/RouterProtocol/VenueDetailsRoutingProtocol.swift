//
//  VenueDetailsRoutingProtocol.swift
//  Foursquare_clone_app
//
//  Created by maks on 26.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

typealias VenueDetailsStoryCompletion = ((_ result: VenueDetailsStoryResult) -> Void)

protocol VenueDetailsRoutingProtocol {
    func showVenueDetailsStory(from: UIViewController,
                               type: VenueDetailsStoryType,
                               model: ViewModel,
                               animated: Bool,
                               completion: @escaping VenueDetailsStoryCompletion)
    func hideVenueDetailsStory(animated: Bool)
}
