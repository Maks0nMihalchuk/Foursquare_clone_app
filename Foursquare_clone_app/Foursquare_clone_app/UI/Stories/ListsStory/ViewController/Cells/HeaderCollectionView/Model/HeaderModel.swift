//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 06.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

enum TypeHeader: String {
    case yours
}

struct HeaderName {
    let title: String
    let type: String
}

let listOfHeaderNames = [HeaderName(title: "HeaderNameTitle.YourPlaces"
                            .localized(name: "ListVCLocalization"),
                                    type: "yours"),
                         HeaderName(title: "HeaderNameTitle.ListsYouCreated"
                            .localized(name: "ListVCLocalization"),
                                    type: "created")]
