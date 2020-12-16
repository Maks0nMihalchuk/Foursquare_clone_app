//
//  CollectionViewModel.swift
//  Foursquare_clone_app
//
//  Created by maks on 14.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

struct StandardCategoriesModel {
    let imageName: String
    let title: String
}

let arrayStandardCategories = [StandardCategoriesModel(imageName: "breakfast", title: "Breakfast"),
                  StandardCategoriesModel(imageName: "lunch", title: "Lunch"),
                  StandardCategoriesModel(imageName: "dinner", title: "Dinner"),
                  StandardCategoriesModel(imageName: "coffee&tea", title: "Coffee & Tea"),
                  StandardCategoriesModel(imageName: "nightlife", title: "Nightlife"),
                  StandardCategoriesModel(imageName: "thingsToDo", title: "Things to do")]
