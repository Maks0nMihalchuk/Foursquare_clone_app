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
    let categories: String
    let location: String
    let rating: String
    let ratingColor: String
    let prefix: String?
    let suffix: String?
    let hoursStatus: String
    let phone: String
    let timeframes: [String: String]
    let webSite: String
    let tierPrice: String
    let messagePrice: String
    let currencyPrice: String
}
