//
//  ViewModel.swift
//  Foursquare_clone_app
//
//  Created by maks on 21.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit
import Kingfisher

enum TierKeys {
    case firstLevelPrice
    case secondLevelPrice
    case thirdLevelPrice
    case fourthLevelPrice

    var currentLevelPrice: String {
        switch self {
        case .firstLevelPrice:
            return "$"
        case .secondLevelPrice:
            return "$$"
        case .thirdLevelPrice:
            return "$$$"
        case .fourthLevelPrice:
            return "$$$$"
        }
    }
}

struct DetailViewModel {

    private let defaultRating = "-"
    private let defaultColor = "858585"
    private let dataModel: DetailVenueModel

    init(dataModel: DetailVenueModel) {
        self.dataModel = dataModel
    }

    var imageURL: URL? {
        return getPhotoURL(prefix: dataModel.prefix, suffix: dataModel.suffix, with: .middle)
    }

    var venueName: String {
        return dataModel.name
    }

    var nameVenueAndPrice: String {
        return "\(dataModel.name) \n \(price)"
    }

    var price: String {
        let tier = getTierPrice()
        let message = getMessagePrice()

        if message.isEmpty {
            return message
        } else {
            return "\(message) - \(tier)"
        }
    }

    var location: String {
        return getLocation()
    }

    var categories: String {
        return getCategories()
    }

    var phone: String {
        guard let phone = dataModel.phone else {
            return "Add Phone".localized(name: "DetailVCLocalization")
        }

        return phone
    }

    var website: String {
        guard let website = dataModel.webSite else {
            return "Add Website".localized(name: "DetailVCLocalization")
        }

        return website
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

    var detailDays: String {
        return getDetailDays()
    }

    var detailHours: String {
        return getDetailHours()
    }
}

// MARK: - converting data from DetailVenueModel to ViewModel
private extension DetailViewModel {

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

    func getDetailDays() -> String {
        guard let timeframesDays = dataModel.timeframesDays else {
            return ""
        }

        var days = String()
        timeframesDays.forEach({
            days += "\($0) \n"
        })

        if days.hasSuffix("\n") {
            days.removeLast(2)
        }

        return days
    }

    func getDetailHours() -> String {
        guard let timeframesHours = dataModel.timeframesRenderedTime else {
            return ""
        }

        var hours = String()
        timeframesHours.forEach({
            hours += "\($0) \n"
        })

        if hours.hasSuffix("\n") {
            hours.removeLast(2)
        }

        return hours
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

    func getMessagePrice() -> String {
        guard let message = dataModel.messagePrice else {
            return ""
        }

        return message
    }

    func getTierPrice() -> String {
        guard let tier = dataModel.tierPrice else {
            return ""
        }

        switch tier {
        case 1:
            return TierKeys.firstLevelPrice.currentLevelPrice
        case 2:
            return TierKeys.secondLevelPrice.currentLevelPrice
        case 3:
            return TierKeys.thirdLevelPrice.currentLevelPrice
        case 4:
            return TierKeys.fourthLevelPrice.currentLevelPrice
        default:
            return ""
        }
    }
}
