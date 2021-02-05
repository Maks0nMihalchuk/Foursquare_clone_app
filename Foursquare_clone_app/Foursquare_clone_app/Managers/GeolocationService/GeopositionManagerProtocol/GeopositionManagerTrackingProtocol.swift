//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 05.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

protocol GeopositionManagerTrackingProtocol {
    func startTrackLocation(withCompletion completion: @escaping GeopositionObserverCompletionBlock)
    func stopTrackLocation()
}
