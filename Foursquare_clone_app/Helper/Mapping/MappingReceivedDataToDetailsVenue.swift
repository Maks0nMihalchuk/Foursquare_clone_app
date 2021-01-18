//
//  Mapping.swift
//  Foursquare_clone_app
//
//  Created by maks on 18.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

enum PriceKey {
    case tier
    case message
    case currency
}

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

class MappingReceivedDataToDetailsVenue {
    static var shared: MappingReceivedDataToDetailsVenue = {
        let mapping = MappingReceivedDataToDetailsVenue()
        return mapping
    }()

    func mappingReceivedDataToDetailsVenue(apiModel: DetailVenue) -> DetailVenueModel {
        let price = apiModel.price
        let venueName = apiModel.name
        let prefix = apiModel.bestPhoto?.prefix
        let suffix = apiModel.bestPhoto?.suffix

        let location = getLocation(location: apiModel.location.formattedAddress)
        let timeFramesDays = getTimeFramesDays(of: apiModel.hours?.timeframes)
        let timeFramesRenderedTime = getTimeFramesRenderedTime(of: apiModel.hours?.timeframes)
        let messagePrice = getPrice(with: price, by: .message)
        let tierPrice = "\(messagePrice) - \(getPrice(with: price, by: .tier))"
        let currencyPrice = getPrice(with: price, by: .currency)
        let categories = getCetegories(model: apiModel)

        let rating: String = {

            guard let rating = apiModel.rating else {
                return "-"
            }

            return String(rating)
        }()

        let ratingColor: String = {

            guard let color = apiModel.ratingColor else {
                return "858585"
            }

            return color
        }()

        let hoursStatus: String = {

            guard let hoursStatus = apiModel.hours?.status else {
                return "Add Hours"
            }

            return hoursStatus
        }()

        let phone: String =  {

            guard let phone = apiModel.contact?.formattedPhone else {
                return "Add Phone"
            }

            return phone
        }()

        let webSite: String = {

            guard let urlString = apiModel.url else {
                return "Add Website"
            }

            return urlString
        }()

        return DetailVenueModel(name: venueName, categories: categories,
                                location: location, rating: rating,
                                ratingColor: ratingColor, prefix: prefix,
                                suffix: suffix, hoursStatus: hoursStatus,
                                phone: phone, timeframesDays: timeFramesDays,
                                timeframesRenderedTime: timeFramesRenderedTime,
                                webSite: webSite, tierPrice: tierPrice,
                                messagePrice: messagePrice, currencyPrice: currencyPrice)
    }
}

private extension MappingReceivedDataToDetailsVenue {
    func getCetegories (model: DetailVenue) -> String {
        let categories: String = {
            var category = ""

            if model.categories.count == 0 {
                return ""
            }

            model.categories.forEach {
                category += "\($0.name), "
            }

            if category.hasSuffix(", ") {
                category.removeLast(2)
            }

            return category
        }()
        return categories
    }
    func getPrice (with price: Price?, by key: PriceKey) -> String {

        guard let price = price else {
            return ""
        }

        switch key {
        case .tier:
            return tierKeyForPrice(tier: getPriceTier(price: price))
        case .message:
            return getPriceMessage(price: price)
        case .currency:
            return getPriceCurrency(price: price)
        }
    }

    func getPriceTier (price: Price) -> Int {
        return price.tier
    }

    func getPriceMessage (price: Price) -> String {
        return price.message
    }

    func getPriceCurrency (price: Price) -> String {
        return price.currency
    }

    func tierKeyForPrice (tier: Int) -> String {
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

    func getTimeFramesDays (of timeframes: [TimeFrames]?) -> String {
        guard let timeframes = timeframes else {
            return "Add Hours"
        }

        let timeFramesDays: String = {
            var days = String()
            timeframes.forEach {
                days += "\($0.days) \n"
            }
            return days
        }()
        return timeFramesDays
    }

    func getTimeFramesRenderedTime (of timeframes: [TimeFrames]?) -> String {
        guard let timeframes = timeframes else {
            return "Add Hours"
        }

        let timeFramesTime: String = {
            var renderedTime = String()
            timeframes.forEach({ (time) in
                time.open?.forEach({
                    renderedTime += "\($0.renderedTime) \n"
                })
            })
            return renderedTime
        }()
        return timeFramesTime
    }

    func getLocation (location: [String]) -> String {

        var getLocation = String()
        location.forEach {
            getLocation += "\($0), "
        }

        if getLocation.hasSuffix(", ") {
            getLocation.removeLast(2)
        }
        return getLocation
    }
}