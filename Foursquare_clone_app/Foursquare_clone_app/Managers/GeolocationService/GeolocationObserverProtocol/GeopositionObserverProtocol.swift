//
//  ObserverProtocol.swift
//  Foursquare_clone_app
//
//  Created by maks on 28.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

protocol GeopositionObserverProtocol: class {
    func geolocationManager(_ manager: GeolocationManagerProtocol,
                            didChangeStatus status: GeopositionManagerStatus)
    func geolocationManager(_ manager: GeolocationManagerProtocol,
                            didUpdateLocation location: Geopoint)
}
