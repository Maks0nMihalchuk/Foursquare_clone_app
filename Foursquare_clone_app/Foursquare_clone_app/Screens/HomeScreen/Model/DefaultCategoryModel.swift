//
//  CollectionViewModel.swift
//  Foursquare_clone_app
//
//  Created by maks on 14.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

struct DefaultCategory {
    let imageName: String
    let title: String
}

let defaultCategoriesList = [DefaultCategory(imageName: "breakfast",
                                             title: "HomeViewController.BreakfastTitle".localized()),
                             DefaultCategory(imageName: "lunch",
                                             title: "HomeViewController.LunchTitle".localized()),
                             DefaultCategory(imageName: "dinner",
                                             title: "HomeViewController.DinnerTitle".localized()),
                             DefaultCategory(imageName: "coffee&Tea",
                                             title: "HomeViewController.CoffeeAndTeaTitle".localized()),
                             DefaultCategory(imageName: "nightlife",
                                             title: "HomeViewController.NightlifeTitle".localized()),
                             DefaultCategory(imageName: "thingsToDo",
                                             title: "HomeViewController.ThingsToDoTitle".localized())]
