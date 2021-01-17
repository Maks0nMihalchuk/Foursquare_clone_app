//
//  ItemUser.swift
//  Foursquare_clone_app
//
//  Created by maks on 21.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

struct Hours: Codable {
    let status: String
    let timeframes: [TimeFrames]?
}

struct TimeFrames: Codable {
    let days: String
    let open: [Open]?
}

struct Open: Codable {
    let renderedTime: String
}
