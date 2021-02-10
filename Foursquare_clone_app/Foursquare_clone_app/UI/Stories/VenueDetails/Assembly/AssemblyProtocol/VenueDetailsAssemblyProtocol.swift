//
//  VenueDetailsAssemblyProtocol.swift
//  Foursquare_clone_app
//
//  Created by maks on 26.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

protocol VenueDetailsAssemblyProtocol {
    func assemblyDetailWithTableViewVC() -> DetailViewController?
    func assemblyDetailWithScrollViewVC() -> ScrollViewDetailViewController?
    func assemblyFullScreenImageVC() -> FullScreenImageViewController?
}
