//
//  Model.swift
//  Foursquare_clone_app
//
//  Created by maks on 18.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

struct DetailVenueModel {
    let name: String
    let categories: [String]
    let address: String?
    let lat: Double
    let long: Double
    let location: [String]
    let rating: Double?
    let ratingColor: String?
    let prefix: String?
    let suffix: String?
    let hoursStatus: String?
    let phone: String?
    let timeframesDays: [String]?
    let timeframesRenderedTime: [String]?
    let webSite: String?
    let tierPrice: Int?
    let messagePrice: String?
}
