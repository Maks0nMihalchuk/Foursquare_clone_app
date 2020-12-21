//
//  Item.swift
//  Foursquare_clone_app
//
//  Created by maks on 21.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

struct Item: Codable {
    let text: String?
    let prefix: String?
    let suffix: String?
    let user: ItemUser?
    let photo: String?
}
