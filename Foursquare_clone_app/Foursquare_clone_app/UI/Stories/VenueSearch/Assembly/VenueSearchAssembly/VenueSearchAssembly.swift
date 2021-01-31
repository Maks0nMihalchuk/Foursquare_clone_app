//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 31.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class VenueSearchAssembly: VenueSearchAssemblyProtocol {

    func assemblySearchVC() -> SearchViewController? {
        let controllerID = String(describing: SearchViewController.self)
        let searchConroller = getStoryboard()
            .instantiateViewController(identifier: controllerID) as? SearchViewController
        return searchConroller
    }
}

// MARK: - getStoryboard
private extension VenueSearchAssembly {

    func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "VenueSearchStoryboard", bundle: nil)
    }
}
