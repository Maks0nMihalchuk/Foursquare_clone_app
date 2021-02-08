//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 31.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

enum VenueSearchStoryResult {
    case success
    case userCancelation
    case failure(error: Error?)
}
