//
//  MapAssembly.swift
//  Foursquare_clone_app
//
//  Created by maks on 13.02.2021.
//  Copyright © 2021 maks. All rights reserved.
// swiftlint:disable force_cast

import Foundation
import UIKit

class MapAssembly: MapAssemblyProtocol {

    func assemblyMapViewController() -> MapViewController {
        let controllerID = String(describing: MapViewController.self)
        let mapController = getStoryboard()
            .instantiateViewController(withIdentifier: controllerID)
            as! MapViewController
        return mapController
    }
}

// MARK: - getStoryboard
private extension MapAssembly {

    func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "MapStoryboard", bundle: nil)
    }
}
