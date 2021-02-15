//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 05.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

typealias GeopositionObserverCompletionBlock = (_ result: GeopositionObservingResult) -> Void

enum GeopositionObservingResult {
    case success(newPosition: Geopoint)
    case failure(error: GeopositionObservingError)
}

enum GeopositionObservingError: Error {
    case locationUnknown
    case locationAccessDenied
    case internetIsNotAvailable
}
