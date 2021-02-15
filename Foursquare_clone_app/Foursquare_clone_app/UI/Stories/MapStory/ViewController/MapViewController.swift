//
//  MapViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 13.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate: class {
    func mapViewController(_ viewController: MapViewController,
                           didTapBack button: UIBarButtonItem)
    func mapViewController(_ viewController: MapViewController,
                           didTapFindUserLocationButton button: UIButton,
                           on mapView: MKMapView,
                           with locationServicesEnabled: Bool)
    func mapViewController(_ viewController: MapViewController,
                           didTapMapViewZoomButton button: UIButton,
                           on mapView: MKMapView, by key: KeyToScaleMapView)

}

class MapViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!

    var viewModel: ShortInfoViewModel?

    weak var delegate: MapViewControllerDelegate?

    private var customAnnotationView: BriefDescriptionVenueView?
    private let latitudinalMeters: Double = 500
    private let longitudinalMeters: Double = 500
    private let annotation = MKPointAnnotation()
    private let markerID = "Marker"

    private lazy var backButton: UIBarButtonItem = {
        let image = UIImage(named: "backWhiteArrow")
        let button = UIBarButtonItem(image: image, style: .plain, target: self,
                                     action: #selector(screenCloseButtonPressed(_:)))
        button.tintColor = .white
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupMapView()
        setupAnnotationMapView()
        setupRegion()
    }

    @IBAction func didTapButtonZoomIn(_ sender: UIButton) {
        delegate?.mapViewController(self, didTapMapViewZoomButton: sender, on: mapView, by: .zoomIn)
    }

    @IBAction func didTapButtonZoomOut(_ sender: UIButton) {
        delegate?.mapViewController(self, didTapMapViewZoomButton: sender, on: mapView, by: .zoomOut)
    }

    @IBAction func didTapFindUserLocationButton(_ sender: UIButton) {
        delegate?.mapViewController(self,
                                    didTapFindUserLocationButton: sender,
                                    on: mapView,
                                    with: CLLocationManager.locationServicesEnabled())
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        var markerView: MKMarkerAnnotationView

        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: markerID)
            as? MKMarkerAnnotationView {
            view.annotation = annotation
            markerView = view
        } else {
            markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: markerID)
            markerView.detailCalloutAccessoryView = setupCustomAnnotationView(width: markerView.bounds.width)
            markerView .canShowCallout = true
        }

        return markerView
    }
}

// MARK: - setup custom annotation View
private extension MapViewController {

    func setupCustomAnnotationView(width: CGFloat) -> BriefDescriptionVenueView {
        let view = UIView.fromNib() as BriefDescriptionVenueView
        view.setupUI(viewModel: viewModel)
        let widthConstraint = NSLayoutConstraint(item: view,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: view.bounds.width)
        let heightConstraint = NSLayoutConstraint(item: view,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: view.bounds.height)
        view.addConstraint(widthConstraint)
        view.addConstraint(heightConstraint)
        customAnnotationView = view
        return view
    }
}

// MARK: - setup mapView
private extension MapViewController {

    func setupMapView() {
        mapView.delegate = self
    }

    func setupAnnotationMapView() {
        guard let model = viewModel else { return }

        let latitude = model.coordinates.lat
        let longitude = model.coordinates.long
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude,
                                                       longitude: longitude)
        annotation.title = model.address
        mapView.addAnnotation(annotation)
    }

    func setupRegion() {
        let region = MKCoordinateRegion(center: annotation.coordinate,
                                        latitudinalMeters: latitudinalMeters,
                                        longitudinalMeters: longitudinalMeters)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - setup NavigationBar
private extension MapViewController {

    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        let navBar = navigationController?.navigationBar
        navigationItem.leftBarButtonItem = backButton
        title = "ShowView".localized()
        navBar?.barTintColor = .systemBlue
        navBar?.backgroundColor = .systemBlue
        navBar?.barTintColor = .systemBlue
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white,
                                      .font: UIFont.boldSystemFont(ofSize: 22)]
    }

    @objc func screenCloseButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.mapViewController(self, didTapBack: sender)
    }
}
