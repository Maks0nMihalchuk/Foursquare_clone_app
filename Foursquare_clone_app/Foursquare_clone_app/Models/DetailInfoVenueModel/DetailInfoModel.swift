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
    let location: DetailLocation
    let categories: [DetailCategory]
    let rating: Double?
    let ratingColor: String?
    let photos: Listed?
    let tips: Listed?
}

struct DetailLocation: Codable {
    let formattedAddress: [String]
}

struct DetailCategory: Codable {
    let name: String
}

struct Photo: Codable {

    let prefix: String
    let suffix: String
}

struct Listed: Codable {
    let groups: [HereNowGroup]?
}

struct HereNowGroup: Codable {
    let items: [Item]?

}

struct Item: Codable {
    let text: String?
    let prefix: String?
    let suffix: String?
    let user: ItemUser?
    let photo: String?
}

struct ItemUser: Codable {
    let firstName: String?
    let lastName: String?
}
