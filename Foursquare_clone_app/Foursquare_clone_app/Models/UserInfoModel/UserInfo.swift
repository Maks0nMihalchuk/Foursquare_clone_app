//
//  UserInfo.swift
//  Foursquare_clone_app
//
//  Created by maks on 04.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

struct User: Codable {
    let response: Response
}

struct Response: Codable {
    let user: UserInfo
}

struct UserInfo: Codable {
    let firstName: String
    let lastName: String
    let photo: UserPhoto
    let friends: UserFriends
    let tips: UserTips
    let photos: UserPhotos
    let lists: UserLists
}

struct UserPhoto: Codable {
    let prefix: String
    let suffix: String
    let `default`: Bool
}

struct UserFriends: Codable {
    let count: Int
}

struct UserTips: Codable {
    let count: Int
}

struct UserPhotos: Codable {
    let count: Int
}

struct UserLists: Codable {
    let count: Int
    let groups: [UserListsGroups]
}

struct UserListsGroups: Codable {
    let items: [UserListItems]
}

struct UserListItems: Codable {
    let name: String
    let followers: UserFollowers?
}

struct UserFollowers: Codable {
    let count: Int
}
