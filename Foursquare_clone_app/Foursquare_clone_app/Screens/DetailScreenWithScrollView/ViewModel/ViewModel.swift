//
//  ViewModel.swift
//  Foursquare_clone_app
//
//  Created by maks on 21.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

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

struct ViewModel {
    private let defaultRating = "-"
    private let defaultColor = "858585"
    private let dataModel: DetailVenueModel

    init(dataModel: DetailVenueModel) {
        self.dataModel = dataModel
    }

    var name: String {
        return "\(dataModel.name) \n \(price)"
    }

    var price: String {
        let tier = getTierPrice()
        let message = getMessagePrice()

        return "\(message) - \(tier)"
    }

    var location: String {
        return getLocation()
    }
    var categories: String {
        return getCategories()
    }

    var urlForPhoto: URL? {
        let url = getURLForBestPhoto()
        return url
    }

    var phone: String {
        guard let phone = dataModel.phone else {
            return "Add Phone".localized()
        }

        return phone
    }

    var website: String {
        guard let website = dataModel.webSite else {
            return "Add Website".localized()
        }

        return website
    }

    var rating: String {

        guard let rating = dataModel.rating else {
            return defaultRating
        }

        return String(rating)
    }

    var ratingColor: UIColor {
        guard let hexColor = dataModel.ratingColor else {
            return UIColor(hexString: defaultColor)
        }

        return UIColor(hexString: hexColor)
    }

    var hoursStatus: String {
        guard let status = dataModel.hoursStatus else {
            return "Add Hours".localized()
        }

        return status
    }
}

// MARK: - converting data from DetailVenueModel to ViewModel
private extension ViewModel {

    func getURLForBestPhoto() -> URL? {
        guard
            let prefix = dataModel.prefix,
            let suffix = dataModel.suffix
        else {
            return nil
        }

        let urlString = "\(prefix)500x500\(suffix)"
        let url = URL(string: urlString)

        return url
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
                return "Add Categories".localized()
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
