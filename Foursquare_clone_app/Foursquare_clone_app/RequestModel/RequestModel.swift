//
//  Model.swift
//  Foursquare_clone_app
//
//  Created by maks on 16.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

struct Request: Codable {
    let response: Response
}

struct Response: Codable {
    let venues: [Venue]
}

struct Venue: Codable {
    let name: String
    let categories: [Category]
}
