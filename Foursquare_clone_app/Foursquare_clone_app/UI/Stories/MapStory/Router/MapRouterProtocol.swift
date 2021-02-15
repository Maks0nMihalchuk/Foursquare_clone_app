//
//  MapRouterProtocol.swift
//  Foursquare_clone_app
//
//  Created by maks on 13.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

typealias MapStoryCompletion = ((_ result: MapStoryResult) -> Void)

protocol MapRouterProtocol {
    func showMapStory(from: UIViewController,
                      model: ShortInfoViewModel,
                      animated: Bool,
                      completion: @escaping MapStoryCompletion)
    func hideMapStory(animated: Bool)
}
