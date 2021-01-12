//
//  StorageManager.swift
//  Foursquare_clone_app
//
//  Created by maks on 11.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

class StorageManager {

    static var shared: StorageManager = {
        let storageManager = StorageManager()
        return storageManager
    }()

    var infoAboutUserLists = [GetUserListsGroup]()
    var detailsVanue: DetailsVenue?
    var venues = [Venue]()
}
