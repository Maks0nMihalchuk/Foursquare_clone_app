//
//  GeolocationManager.swift
//  Foursquare_clone_app
//
//  Created by maks on 28.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit
import CoreLocation

protocol GeopositionManagerPriotocol: GeopositionManagerTrackingProtocol {
    var currentManagerStatus: GeopositionManagerStatus? { get }

    func getCurrentPosition() -> Geopoint?
}

private struct GeopositionManagerDefaults {
    static let locationDistanceFilter: CLLocationDistance = 300
    static let locationAccuracy: CLLocationAccuracy = kCLLocationAccuracyHundredMeters
    static let allowBackgroundLocationUpdates: Bool = false
}

class GeopositionManager: NSObject {
    static let shared = GeopositionManager()

    fileprivate let locationManager = CLLocationManager()
    fileprivate var observers = [GeopositionObserverProtocol]()
    fileprivate var completion: GeopositionObserverCompletionBlock?
    fileprivate var position: Geopoint?

    fileprivate(set) public var currentManagerStatus: GeopositionManagerStatus? = .stopped {
        didSet {
            self.notifyObservers(aboutManagerStatus: self.currentManagerStatus)
        }
    }

    override init() { }

    deinit {
        stopTrackLocation()
    }

    fileprivate func locationManagerSetting() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = GeopositionManagerDefaults.allowBackgroundLocationUpdates
        locationManager.distanceFilter = GeopositionManagerDefaults.locationDistanceFilter
        locationManager.desiredAccuracy = GeopositionManagerDefaults.locationAccuracy
    }
}

// MARK: - GeopositionManagerPriotocol
extension GeopositionManager: GeopositionManagerPriotocol {

    func getCurrentPosition() -> Geopoint? {
        return position
    }
}

// MARK: - GeopositionManagerTrackingProtocol
extension GeopositionManager: GeopositionManagerTrackingProtocol {

    func startTrackLocation(withCompletion completion: @escaping GeopositionObserverCompletionBlock) {
        guard self.currentManagerStatus != .started else { return }

        currentManagerStatus = .started
        self.completion = completion

        locationManagerSetting()

        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func stopTrackLocation() {
        guard currentManagerStatus != .stopped else { return }

        currentManagerStatus = .stopped
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - GeopositionObserverSubscriptionProtocol
extension GeopositionManager: GeopositionObserverSubscriptionProtocol {

    func subscribeForGeopositionChanges(observer: GeopositionObserverProtocol) {
        observers.append(observer)
    }

    func unsubscribeFromGeopositionChanges(observer: GeopositionObserverProtocol) {
        if let index = observers.firstIndex(where: {$0 === observer}) {
            observers.remove(at: index)
        }
    }

    fileprivate func notifyObservers(aboutGeopositionChange newGeopoint: Geopoint) {
        observers.forEach { $0.geopositionManager(self, didUpdateLocation: newGeopoint)}
    }

    fileprivate func notifyObservers(aboutManagerStatus status: GeopositionManagerStatus?) {
        guard let requiredStatus = status else { return }

        observers.forEach { $0.geopositionManager(self, didChangeStatus: requiredStatus)}
    }
}

// MARK: - CLLocationManagerDelegate
extension GeopositionManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        let position = Geopoint(latitude: location.coordinate.latitude,
                                longitude: location.coordinate.longitude)

        if let requiredCompletionBlock = completion {
            requiredCompletionBlock(.success(newPosition: position))
            completion = nil
        }
        self.position = position
        notifyObservers(aboutGeopositionChange: position)

    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let requiredCompletionBlock = completion else { return }

        switch status {
        case .denied, .notDetermined, .restricted:
            requiredCompletionBlock(.failure(error: .locationAccessDenied))
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }

        completion = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let requiredCompletion = completion else { return }

        defer {
            completion = nil
        }

        let errorCode = (error as NSError).code

        switch errorCode {
        case 0:
            requiredCompletion(.failure(error: .locationUnknown))
        case 1:
            requiredCompletion(.failure(error: .locationAccessDenied))
        case 2:
            requiredCompletion(.failure(error: .internetIsNotAvailable))
        default: break
        }
    }
}
