//
//  DefaultImage.swift
//  Foursquare_clone_app
//
//  Created by maks on 07.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

enum DefaultImage {
    case userImageDefault
    case userImageWithHeart
    case userImageWithBookmark

    var switchImage: String {
        switch self {
        case .userImageDefault:
            return "userImageDefault"
        case .userImageWithBookmark:
            return "userImageWithBookmark"
        case .userImageWithHeart:
            return "userImageWithHeart"
        }
    }
}
