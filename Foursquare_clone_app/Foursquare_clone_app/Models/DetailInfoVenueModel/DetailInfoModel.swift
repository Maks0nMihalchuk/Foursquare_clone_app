//
//  DetailInfoModel.swift
//  Foursquare_clone_app
//
//  Created by maks on 17.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

struct DetailInfo: Codable {
    let response: DetailVenueResponse
}

struct DetailVenueResponse: Codable {
    let venue: DetailVenue
}

struct DetailVenue: Codable {
    let name: String
    let location: DetailLocation?
    let categories: [DetailCategory]?
    let rating: Double?
    let ratingColor: String?
    let photos: Listed?
    let tips: Listed?
}
