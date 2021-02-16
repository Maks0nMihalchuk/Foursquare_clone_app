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

class MapRouter: MapRoutingProtocol {

    private var completion: MapStoryCompletion?
    private var mapController: MapViewController?
    private let assembly: MapAssemblyProtocol

    init(assembly: MapAssemblyProtocol) {
        self.assembly = assembly
    }

    func showMapStory(from: UIViewController,
                      viewModel: ShortInfoViewModel,
                      animated: Bool,
                      completion: @escaping MapStoryCompletion) {
        self.completion = completion

        let mapController = assembly.assemblyMapViewController()
        mapController.delegate = self
        mapController.viewModel = viewModel
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
                           locationServicesStatus status: CLAuthorizationStatus) {

        switch status {

        case .authorizedAlways, .authorizedWhenInUse:
            mapView.setUserTrackingMode(.follow, animated: true)
            mapView.showsUserLocation = true
        case .notDetermined, .restricted, .denied:
            let alertTitle = "AlertErrorTitle".localized(name: "MapVCLocalization")
            let alertMessage = "AlertErrorMessage".localized(name: "MapVCLocalization")
            let alertActionTitle = "AlertActionTitle".localized(name: "MapVCLocalization")
            showErrorAboutMissingUserGeolocation(viewController,
                                                 alert: (title: alertTitle,
                                                         message: alertMessage),
                                                 alertButton: alertActionTitle)
        @unknown default:
            break
        }
    }

    func mapViewController(_ viewController: MapViewController,
                           didTapMapViewZoomButton button: UIButton,
                           on mapView: MKMapView, state: MapViewScaleState) {
        var region = mapView.region

        switch state {

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
