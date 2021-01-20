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

    private var userLists = [GetUserListsGroup]()
    private var detailsVanue: DetailVenueModel?
    private var venues = [Venue]()

    func putUserIntoArray (of list: [GetUserListsGroup]) {
        userLists = list
    }

    func getUserLists () -> [GetUserListsGroup] {
        return userLists
    }

    func putDetailVanue (of detailVenues: DetailVenueModel) {
        detailsVanue = detailVenues
    }

    func getDetailVanue () -> DetailVenueModel? {
        return detailsVanue
    }

    func putVenues (of venues: [Venue]) {
        self.venues = venues
    }

    func getVenues () -> [Venue] {
        return venues
    }
}
