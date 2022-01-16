//
//  RequestModelPOST.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

enum KeyForList {
    case listName
    case description
    case collaborative

    var currentKey: String {
        switch self {
        case .listName:
            return "name"
        case .description:
            return "description"
        case .collaborative:
            return "collaborative"
        }
    }
}

var configureListOptions = [String: Any]()
