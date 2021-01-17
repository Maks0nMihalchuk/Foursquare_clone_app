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
        let timeFrames = getTimeFrames(of: apiModel.hours?.timeframes)
        let tierPrice = getPrice(with: price, by: .tier)
        let messagePrice = getPrice(with: price, by: .message)
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
                                phone: phone, timeframes: timeFrames,
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
            return getPriceTier(price: price)
        case .message:
            return getPriceMessage(price: price)
        case .currency:
            return getPriceCurrency(price: price)
        }
    }

    func getPriceTier (price: Price) -> String {
        return "\(price.tier)"
    }

    func getPriceMessage (price: Price) -> String {
        return "\(price.message)"
    }

    func getPriceCurrency (price: Price) -> String {
        return price.currency
    }

    func getTimeFrames (of timeframes: [TimeFrames]?) -> [String: String] {
        guard let timeframes = timeframes else {
            return ["Add Hours": ""]
        }
         let timeFramesDays: [String] = {
            var days = [String]()
            timeframes.forEach {
                days.append($0.days)
            }
            return days
        }()
        let timeFramesTime: [String] = {
            var renderedTime = [String]()
            timeframes.forEach({ (time) in
                time.open?.forEach({
                    renderedTime.append($0.renderedTime)
                })
            })
            return renderedTime
        }()

        var timeFrames = [String: String]()

        timeFramesDays.enumerated().forEach {
            timeFrames[$0.element] = timeFramesTime[$0.offset]
        }

        return timeFrames
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
