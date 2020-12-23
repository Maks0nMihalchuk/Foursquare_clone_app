//
//  StringExtension.swift
//  Foursquare_clone_app
//
//  Created by maks on 22.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

extension String {
    func localized (name: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: name, bundle: .main, value: "**\(self)**", comment: "")
    }
}
