//
//  HoursCellModel.swift
//  Foursquare_clone_app
//
//  Created by maks on 18.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

struct HoursCellModel {
    let hoursStatus: String
    let detailHours: DetailHours
    var state: Bool
}

struct DetailHours {
    let days: String
    let detailHours: String
}

enum State {
    case folded
    case decomposed
}
