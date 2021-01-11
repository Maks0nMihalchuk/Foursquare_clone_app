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

struct GetUserListsGroup: Codable {
    let type: String
    let name: String
    let count: Int
    let items: [GetUserListsGroupItems]
}

struct GetUserListsGroupItems: Codable {
    let name: String
    let description: String
    let placesSummary: String
    let editable: Bool
    let `public`: Bool
    let collaborative: Bool
    let photo: GetPhoto?
    let listItems: ListItems
}

struct ListItems: Codable {
    let count: Int
}

struct GetPhoto: Codable {
    let prefix: String?
    let suffix: String?
}
