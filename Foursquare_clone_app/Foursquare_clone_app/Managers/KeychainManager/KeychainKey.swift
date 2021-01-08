//
//  KeychainKey.swift
//  Foursquare_clone_app
//
//  Created by maks on 04.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

enum KeychainKey {
    case accessToken

    public var currentKey: String {
        switch self {
        case .accessToken: return "accessToken"
        }
    }
}
