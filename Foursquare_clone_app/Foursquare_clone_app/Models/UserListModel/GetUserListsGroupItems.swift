//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 11.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

struct GetUserListsGroupItems: Codable {
    let name: String
    let description: String
    let placesSummary: String
    let editable: Bool
    let `public`: Bool
    let collaborative: Bool
    let photo: GetPhoto?
    let listItems: ListItems
}
