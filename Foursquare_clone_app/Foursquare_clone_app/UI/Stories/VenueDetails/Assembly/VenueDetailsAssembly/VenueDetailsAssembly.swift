//
//  Assembly.swift
//  Foursquare_clone_app
//
//  Created by maks on 26.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class VenueDetailsAssembly: VenueDetailsAssemblyProtocol {

    func assemblyDetailWithTableViewVC() -> DetailViewController? {
        let controllerID = String(describing: DetailViewController.self)
        let detailController = getStoryboard()
            .instantiateViewController(withIdentifier: controllerID) as? DetailViewController

        return detailController
    }

    func assemblyDetailWithScrollViewVC() -> DetailViewControllerWithScrollView? {
        let controllerID = String(describing: DetailViewControllerWithScrollView.self)
        let detailController = getStoryboard()
            .instantiateViewController(withIdentifier: controllerID) as? DetailViewControllerWithScrollView

        return detailController
    }

    func assemblyFullScreenImageVC() -> FullScreenImageViewController? {
        let controllerID = String(describing: FullScreenImageViewController.self)
        let fullScreenImage = getStoryboard()
            .instantiateViewController(withIdentifier: controllerID) as? FullScreenImageViewController

        return fullScreenImage
    }
}

// MARK: - getStoryboard
private extension VenueDetailsAssembly {

    func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "DetailsVenueStoryboard", bundle: nil)
    }
}
