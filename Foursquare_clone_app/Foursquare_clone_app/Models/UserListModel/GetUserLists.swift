//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

struct GetUserLists: Codable {
    let response: GetUserListsResponse
}

struct GetUserListsResponse: Codable {
    let lists: Lists
}

struct Lists: Codable {
    let count: Int
    let groups: [GetUserListsGroup]
}

struct ListItems: Codable {
    let count: Int
}
