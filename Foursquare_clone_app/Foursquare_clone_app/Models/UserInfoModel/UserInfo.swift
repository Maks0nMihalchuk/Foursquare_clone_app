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
}
