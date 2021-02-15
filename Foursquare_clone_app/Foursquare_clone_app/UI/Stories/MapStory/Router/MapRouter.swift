//
//  MapRouter.swift
//  Foursquare_clone_app
//
//  Created by maks on 13.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import MapKit
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
    private let
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

    private func showErrorAboutMissingUserGeolocation(_ viewController: UIViewController,
                                                      alert: (title: String, message: String),
                                                      alertButton title: String) {
        let alertController = UIAlertController(title: alert.title.localized(),
                                                message: alert.message.localized(),
                                                preferredStyle: .alert)
        let okeyButton = UIAlertAction(title: title.localized(), style: .default, handler: nil)

        alertController.addAction(okeyButton)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - MapViewControllerDelegate
extension MapRouter: MapViewControllerDelegate {
    func mapViewController(_ viewController: MapViewController, didTapBack button: UIBarButtonItem) {
        finalizeStory()
    }

    func mapViewController(_ viewController: MapViewController,
                           didTapFindUserLocationButton button: UIButton,
                           on mapView: MKMapView,
                           with locationServicesEnabled: Bool) {
        if locationServicesEnabled {
            mapView.setUserTrackingMode(.follow, animated: true)
            mapView.showsUserLocation = true
        } else {
            showErrorAboutMissingUserGeolocation(viewController,
                                                 alert: (title: "MapViewController.AlertError.Title",
                                                         message: "MapViewController.AlertError.Message"),
                                                 alertButton: "LocationErrorAlert.Action")
        }
    }

    func mapViewController(_ viewController: MapViewController,
                           didTapMapViewZoomButton button: UIButton,
                           on mapView: MKMapView, by key: KeyToScaleMapView) {
        var region = mapView.region

        switch key {

        case .zoomIn:
            region.span.latitudeDelta /= 2
            region.span.longitudeDelta /= 2
        case .zoomOut:
            region.span.latitudeDelta *= 2
            region.span.longitudeDelta *= 2
        }
        mapView.setRegion(region, animated: true)
    }

}
