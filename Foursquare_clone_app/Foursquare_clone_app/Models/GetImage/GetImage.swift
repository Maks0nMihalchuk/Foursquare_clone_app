//
//  ImageSizeKey.swift
//  Foursquare_clone_app
//
//  Created by maks on 29.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

enum ImageSizeKey {
    case small
    case middle
    case big

    var stringValue: String {
        switch self {
        case .small:
            return "200x200"
        case .middle:
            return "400x400"
        case .big:
            return "500x500"
        }
    }
}

func getPhotoURL(prefix: String?, suffix: String?, with size: ImageSizeKey) -> URL? {
    var urlString = String()

    guard
        let prefix = prefix,
        let suffix = suffix
    else { return nil }

    urlString = prefix + size.stringValue + suffix
    let url = URL(string: urlString)
    return url
}
