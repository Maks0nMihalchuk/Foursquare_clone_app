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

let arrayStandardCategories = [StandardCategory(imageName: "breakfast", title: "BreakfastTitle".localized()),
                  StandardCategory(imageName: "lunch", title: "LunchTitle".localized()),
                  StandardCategory(imageName: "dinner", title: "DinnerTitle".localized()),
                  StandardCategory(imageName: "coffee&Tea", title: "CoffeeAndTeaTitle".localized()),
                  StandardCategory(imageName: "nightlife", title: "NightlifeTitle".localized()),
                  StandardCategory(imageName: "thingsToDo", title: "ThingsToDoTitle".localized())]
