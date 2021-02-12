//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 05.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

protocol GeopositionObserverProtocol: class {
    func geopositionManager(_ manager: GeopositionManagerPriotocol,
                            didUpdateLocation location: Geopoint)
    func geopositionManager(_ manager: GeopositionManagerPriotocol,
                            didChangeStatus status: GeopositionManagerStatus)
}

protocol GeopositionObserverSubscriptionProtocol {
    func subscribeForGeopositionChanges(observer: GeopositionObserverProtocol)
    func unsubscribeFromGeopositionChanges(observer: GeopositionObserverProtocol)
}
