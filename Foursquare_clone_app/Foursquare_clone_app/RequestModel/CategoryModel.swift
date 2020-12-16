//
//  CategoryModel.swift
//  Foursquare_clone_app
//
//  Created by maks on 16.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

struct Category: Codable {
    let name: String
    let icon: CategoryIcon
}

struct CategoryIcon: Codable {
    let prefix: String
    let suffix: String

}
