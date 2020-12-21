//
//  Mapping.swift
//  Foursquare_clone_app
//
//  Created by maks on 18.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

class MappingReceivedDataToDetailsVenue {
    static var shared: MappingReceivedDataToDetailsVenue = {
        let mapping = MappingReceivedDataToDetailsVenue()
        return mapping
    }()

    func mappingReceivedDataToDetailsVenue(apiModel: DetailVenue) -> DetailsVenue {
        let categories: [String] = {
            var categories = [String]()
            apiModel.categories?.forEach {
                categories.append($0.name)
            }
            return categories
        }()
        let location: String = {
            var location = String()
            apiModel.location?.formattedAddress.forEach {
                location += "\($0) "
            }
            return location
        }()
        let users: [String] = {
            var users = [String]()
            apiModel.tips?.groups?.first?.items?.forEach({
                users.append("\($0.user?.firstName ?? "") \($0.user?.lastName ?? "")")
            })

            return users
        }()
        let ratingColor: String = {
            if let color = apiModel.ratingColor {
                return color
            } else {
                return "858585"
            }
        }()
        let rating: String = {
            guard let rating = apiModel.rating else {
                return "-"
            }
            return String(rating)
        }()
        let tips: [String] = {
            var tips = [String]()
            apiModel.tips?.groups?.first?.items?.forEach({
                if let text = $0.text {
                    tips.append(text)
                }
            })
            return tips
        }()
        let photo: String = {
            var photo = String()
            if let prefix = apiModel.photos?.groups?.first?.items?.first?.prefix,
                let suffix = apiModel.photos?.groups?.first?.items?.first?.suffix {
                photo = "\(prefix)500x500\(suffix)"
            } else {
                photo = "unknown"
            }
            return photo
        }()
        return DetailsVenue(name: apiModel.name,
                               categories: categories,
                               location: location,
                               user: users,
                               rating: rating,
                               ratingColor: ratingColor,
                               tips: tips,
                               photoStringUrl: photo)
    }
}
