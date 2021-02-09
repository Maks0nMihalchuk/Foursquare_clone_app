//
//  TierKeys.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

enum TierKeys {
    case firstLevelPrice
    case secondLevelPrice
    case thirdLevelPrice
    case fourthLevelPrice

    var currentLevelPrice: String {
        switch self {
        case .firstLevelPrice:
            return "$"
        case .secondLevelPrice:
            return "$$"
        case .thirdLevelPrice:
            return "$$$"
        case .fourthLevelPrice:
            return "$$$$"
        }
    }
}
