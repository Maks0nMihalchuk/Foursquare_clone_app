//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 17.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

enum KeysToCells {
    case imageCell
    case shortInfoCell
    case hoursCell
    case contactsCell

    static var arrayOfKeysForCells: [KeysToCells] {
        return [.imageCell, .shortInfoCell, .hoursCell, .contactsCell]
    }
}

