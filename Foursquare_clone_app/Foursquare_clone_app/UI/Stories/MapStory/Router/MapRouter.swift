//
//  MapRouter.swift
//  Foursquare_clone_app
//
//  Created by maks on 13.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

enum MapStoryResult {
    case success
    case userCancelation
    case failure(error: Error?)
}

class MapRouter: MapRouterProtocol {

    private var completion: MapStoryCompletion?
    private var mapController: MapViewController?
    private let assembly: MapAssemblyProtocol

    init(assembly: MapAssemblyProtocol) {
        self.assembly = assembly
    }

    func showMapStory(from: UIViewController,
                      model: ShortInfoViewModel,
                      animated: Bool,
                      completion: @escaping MapStoryCompletion) {
        self.completion = completion

        let mapController = assembly.assemblyMapViewController()
        mapController.delegate = self
        mapController.viewModel = model
        self.mapController = mapController

        from.navigationController?.pushViewController(mapController, animated: animated)
    }

    func hideMapStory(animated: Bool) {
        guard let controller = mapController else { return }

        controller.navigationController?.popViewController(animated: animated)
        controller.navigationController?.isNavigationBarHidden = true
        mapController = nil
    }

    private func finalizeStory() {
        self.completion?(.userCancelation)
        completion = nil
    }
}

// MARK: - MapViewControllerDelegate
extension MapRouter: MapViewControllerDelegate {
    func mapViewController(_ viewController: MapViewController, didTapBack button: UIBarButtonItem) {
        finalizeStory()
    }
}
