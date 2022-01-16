//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

struct UserInfoDataModel {
    let firstName: String
    let lastName: String
    let photoPrefix: String
    let photoSuffix: String
    let friendsCount: Int
    let tipsCount: Int
    let photosCount: Int
    let followersCount: [Int]
    let arrayOfListNames: [String]
}
