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
    let contact: Contact?
    let location: DetailLocation
    let url: String?
    let price: Price?
    let categories: [DetailCategory]
    let rating: Double?
    let ratingColor: String?
    let bestPhoto: ItemBestPhoto?
    let hours: Hours?
}
