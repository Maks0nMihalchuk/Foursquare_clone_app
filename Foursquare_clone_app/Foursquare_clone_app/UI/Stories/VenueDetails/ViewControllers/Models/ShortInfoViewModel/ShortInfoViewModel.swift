//
//  ShortInfoViewModel.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

struct ShortInfoViewModel {
    private let defaultRating = "-"
    private let defaultColor = "858585"
    private let dataModel: DetailVenueModel

    init (dataModel: DetailVenueModel) {
        self.dataModel = dataModel
    }

    var name: String {
        return dataModel.name
    }

    var address: String {
        guard let adress = dataModel.address else {
            return "LabelTextPlaceholder".localized(name: "DetailVCLocalization")
        }

        return adress
    }

    var coordinates: (lat: Double, long: Double) {
        return (dataModel.lat, dataModel.long)
    }

    var location: String {
        return getLocation()
    }

    var categories: String {
        return getCategories()
    }

    var rating: String {
        return getRating()
    }

    var ratingColor: UIColor {
        return getRatingColor()
    }

    var hoursStatus: String {
        return getHoursStatus()
    }
}

// MARK: - converting data from DetailVenueModel to ShortInfoViewModel
private extension ShortInfoViewModel {

    func getRating() -> String {
        guard let rating = dataModel.rating else {
            return defaultRating
        }

        return String(rating)
    }

    func getRatingColor() -> UIColor {
        guard let hexColor = dataModel.ratingColor else {
            return UIColor(hexString: defaultColor)
        }

        return UIColor(hexString: hexColor)
    }

    func getHoursStatus() -> String {
        guard let status = dataModel.hoursStatus else {
            return "Add Hours".localized(name: "DetailVCLocalization")
        }

        return status
    }

    func getCategories() -> String {
        let categories: String = {
            var category = String()

            if dataModel.categories.isEmpty {
                return "Add Categories".localized(name: "DetailVCLocalization")
            }

            dataModel.categories.forEach {
                category += "\($0), "
            }

            if category.hasSuffix(", ") {
                category.removeLast(2)
            }

            return category
        }()
        return categories
    }

    func getLocation() -> String {
        var location = String()

        dataModel.location.forEach {
            location += "\($0), "
        }

        if location.hasSuffix(", ") {
            location.removeLast(2)
        }
        return location
    }
}
