//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 13.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

enum KeysForSections {
    case sectionOfStandardCells
    case sectionOfUserCells

    static var arrayOfKeysForSection: [KeysForSections] {
        return [.sectionOfStandardCells, .sectionOfUserCells]
    }
}
