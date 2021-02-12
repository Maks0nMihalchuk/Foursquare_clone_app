//
//  UserLists.swift
//  Foursquare_clone_app
//
//  Created by maks on 11.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

struct UserLists: Codable {
    let count: Int
    let groups: [UserListsGroups]
}

struct UserPhotos: Codable {
    let count: Int
}

struct UserListsGroups: Codable {
    let items: [UserListItems]
}

struct UserListItems: Codable {
    let name: String
    let followers: UserFollowers?
}
