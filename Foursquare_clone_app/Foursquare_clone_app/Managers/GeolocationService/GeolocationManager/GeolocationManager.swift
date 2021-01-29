//
//  GeolocationManager.swift
//  Foursquare_clone_app
//
//  Created by maks on 28.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit
import CoreLocation

protocol GeolocationManagerProtocol {
    func locationManagerSetting()
    func startUpdateLocationData()
    func stopUpdateLocationData()
    func getCurrentLocationData(point location: GeoPoint)
    func getStatus() -> TrackLocationStatus
    func askPermissionToUseGeolocation()
}

class GeolocationManager: NSObject {
    static var shared = GeolocationManager()

    private var locationManager = CLLocationManager()
    private lazy var subscribers = [GeolocationObserverProtocol]()

    deinit {
        stopUpdateLocationData()
    }
}

// MARK: - GeolocationSubscriberProtocol
extension GeolocationManager: GeolocationSubscriberProtocol {
    func subscribe(subscribeTo service: GeolocationObserverProtocol) {
        subscribers.append(service)
    }

    func unsubscribe(unsubscribeFrom service: GeolocationObserverProtocol) {
        if let index = subscribers.firstIndex(where: {$0 === service}) {
            subscribers.remove(at: index)
        }
    }
}

// MARK: - GeolocationManagerProtocol
extension GeolocationManager: GeolocationManagerProtocol {

    func locationManagerSetting() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.allowsBackgroundLocationUpdates = false
    }

    func startUpdateLocationData() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdateLocationData() {
        locationManager.stopUpdatingLocation()
    }

    func getCurrentLocationData(point location: GeoPoint) {
        subscribers.forEach {
            $0.geolocationManager(self, didUpdateData: location)
        }
    }

    func getStatus() -> TrackLocationStatus {
        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return .available
        case .denied, .notDetermined, .restricted:
            return .notAvailable
        @unknown default:
            return .notAvailable
        }
    }

    func askPermissionToUseGeolocation() {
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate
extension GeolocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
        stopUpdateLocationData()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let geoPoint = GeoPoint(latitude: latitude, longitude: longitude)

        getCurrentLocationData(point: geoPoint)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        guard let firstSubscribe = subscribers.first else { return }

        switch status {

        case .notDetermined:
            startUpdateLocationData()
        case .restricted, .denied:
            firstSubscribe.geolocationManager(self, showLocationAccess: .notAvailable)
        case .authorizedAlways, .authorizedWhenInUse:
            firstSubscribe.geolocationManager(self, showLocationAccess: .available)
        @unknown default:
            return
        }
    }
}
