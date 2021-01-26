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
        let storyboard = getStoryboard()
        let controllerID = String(describing: DetailViewController.self)
        let detailController = storyboard
            .instantiateViewController(withIdentifier: controllerID) as? DetailViewController

        return detailController
    }

    func assemblyDetailWithScrollViewVC() -> DetailViewControllerWithScrollView? {
        let storyboard = getStoryboard()
        let controllerID = String(describing: DetailViewControllerWithScrollView.self)
        let detailController = storyboard
            .instantiateViewController(withIdentifier: controllerID) as? DetailViewControllerWithScrollView

        return detailController
    }

    func assemblyFullScreenImageVC() -> FullScreenImageViewController? {
        let storyboard = getStoryboard()
        let controllerID = String(describing: FullScreenImageViewController.self)
        let fullScreenImage = storyboard
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
