//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 21.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

struct DetailLocation: Codable {
    let address: String
    let lat: Double
    let lng: Double
    let formattedAddress: [String]
}
