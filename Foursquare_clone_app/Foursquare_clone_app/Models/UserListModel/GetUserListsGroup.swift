//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 11.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

struct GetUserListsGroup: Codable {
    let type: String
    let name: String
    let count: Int
    let items: [GetUserListsGroupItems]
}
