//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 28.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

protocol GeolocationSubscriberProtocol: class {
    func subscribe(subscribeTo service: GeolocationObserverProtocol)
    func unsubscribe(unsubscribeFrom service: GeolocationObserverProtocol)
}
