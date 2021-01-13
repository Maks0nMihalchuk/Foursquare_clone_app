//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 06.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

struct HeaderName {
    let title: String
    let type: String
}

let listOfHeaderNames = [HeaderName(title: "HeaderNameTitle.YourPlaces".localized(), type: "yours"),
                         HeaderName(title: "HeaderNameTitle.ListsYouCreated".localized(), type: "created")]
