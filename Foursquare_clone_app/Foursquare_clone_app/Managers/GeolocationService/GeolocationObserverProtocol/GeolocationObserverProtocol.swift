//
//  ObserverProtocol.swift
//  Foursquare_clone_app
//
//  Created by maks on 28.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

protocol GeolocationObserverProtocol: class {
    func geolocationManager(_ locationManager: GeolocationManager,
                            showLocationAccess status: TrackLocationStatus)
    func geolocationManager(_ locationManager: GeolocationManager,
                            didUpdateData location: GeoPoint)
}
