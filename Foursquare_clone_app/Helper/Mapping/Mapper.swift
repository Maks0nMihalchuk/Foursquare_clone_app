//
//  Mapping.swift
//  Foursquare_clone_app
//
//  Created by maks on 18.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

class Mapper {

    func mapReceivedDataFromDetailsVenue(apiModel: DetailVenue) -> DetailVenueModel {
        let timeframes = apiModel.hours?.timeframes
        let venueName = apiModel.name
        let prefix = apiModel.bestPhoto?.prefix
        let suffix = apiModel.bestPhoto?.suffix
        let rating = apiModel.rating
        let ratingColor = apiModel.ratingColor
        let tierPrice = apiModel.price?.tier
        let messagePrice = apiModel.price?.message
        let website = apiModel.url
        let phone = apiModel.contact?.formattedPhone
        let hoursStatus = apiModel.hours?.status
        let timeframesDays = getTimeFramesDays(of: timeframes)
        let timeframesRenderedTime = getTimeFramesRenderedTime(of: timeframes)
        let address = apiModel.location.address
        let lat = apiModel.location.lat
        let long = apiModel.location.lng
        let location = apiModel.location.formattedAddress
        let categories = getCategories(of: apiModel.categories)

        return DetailVenueModel(name: venueName, categories: categories,
                                address: address, lat: lat, long: long,
                                location: location, rating: rating,
                                ratingColor: ratingColor, prefix: prefix,
                                suffix: suffix, hoursStatus: hoursStatus,
                                phone: phone, timeframesDays: timeframesDays,
                                timeframesRenderedTime: timeframesRenderedTime, webSite: website,
                                tierPrice: tierPrice, messagePrice: messagePrice)
    }

    func mapReceivedDataAboutUser(userData: UserInfo) -> UserInfoDataModel {
        let firstName = userData.firstName
        let lastName = userData.lastName
        let photoPrefix = userData.photo.prefix
        let photoSuffix = userData.photo.suffix
        let friendsCount = userData.friends.count
        let tipsCount = userData.tips.count
        let photosCount = userData.photos.count
        let userListsItem = getUserListsItems(data: userData.lists)
        let userListsName = getUserListsName(listItems: userListsItem)
        let userFollowersCount = getUserFollowers(listItems: userListsItem)

        return UserInfoDataModel(firstName: firstName,
                                 lastName: lastName,
                                 photoPrefix: photoPrefix,
                                 photoSuffix: photoSuffix, 
                                 friendsCount: friendsCount,
                                 tipsCount: tipsCount,
                                 photosCount: photosCount,
                                 followersCount: userFollowersCount,
                                 arrayOfListNames: userListsName)
    }
}

// MARK: - converting data about a place into a convenient form
private extension Mapper {

    func getCategories(of apiModel: [DetailCategory]) -> [String] {
        let categories: [String] = {
            var categories = [String]()
            apiModel.forEach {
                categories.append($0.name)
            }
            return categories
        }()
        return categories
    }

    func getTimeFramesDays(of timeframes: [TimeFrames]?) -> [String]? {
        guard let timeframes = timeframes else {
            return nil
        }

        let timeFrameDays: [String]? = {
            var timeFrameDays: [String]? = []
            timeframes.forEach({
                timeFrameDays?.append($0.days)
            })
            return timeFrameDays
        }()
        return timeFrameDays
    }

    func getTimeFramesRenderedTime(of timeframes: [TimeFrames]?) -> [String]? {
        guard let timeframes = timeframes else {
            return nil
        }

        let renderedTime: [String]? = {
            var renderedTime: [String]? = []
            timeframes.forEach({
                $0.open?.forEach({
                    renderedTime?.append($0.renderedTime)
                })
            })
            return renderedTime
        }()
        return renderedTime
    }
}

// MARK: - converting user data into a convenient form
private extension Mapper {

    func getUserListsItems(data: UserLists) -> [UserListItems] {
        let userGroupsLists = data.groups
        let listItems = userGroupsLists.flatMap {
            $0.items
        }

        return listItems
    }

    func getUserListsName(listItems: [UserListItems]) -> [String] {
        let items = listItems.map {
            $0.name
        }

        return items
    }

    func getUserFollowers(listItems: [UserListItems]) -> [Int] {
        let followers = listItems.compactMap {
            $0.followers?.count
        }

        return followers
    }
}
