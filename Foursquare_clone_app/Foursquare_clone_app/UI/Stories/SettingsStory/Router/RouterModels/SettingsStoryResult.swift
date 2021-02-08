//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

enum SettingsStoryResult {
    case success
    case userCancelation
    case failure(error: Error?)
}
