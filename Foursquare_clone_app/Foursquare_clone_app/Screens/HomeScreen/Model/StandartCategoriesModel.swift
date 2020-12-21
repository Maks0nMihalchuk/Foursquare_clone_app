//
//  CollectionViewModel.swift
//  Foursquare_clone_app
//
//  Created by maks on 14.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

struct StandardCategory {
    let imageName: String
    let title: String
}

let arrayStandardCategories = [StandardCategory(imageName: "breakfast", title: "Breakfast"),
                  StandardCategory(imageName: "lunch", title: "Lunch"),
                  StandardCategory(imageName: "dinner", title: "Dinner"),
                  StandardCategory(imageName: "coffee&Tea", title: "Coffee & Tea"),
                  StandardCategory(imageName: "nightlife", title: "Nightlife"),
                  StandardCategory(imageName: "thingsToDo", title: "Things to do")]
