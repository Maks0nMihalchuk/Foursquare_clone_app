//
//  UserInfoViewModel.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

struct UserInfoViewModel {
    private let dataModel: UserInfoDataModel

    init(dataModel: UserInfoDataModel) {
        self.dataModel = dataModel
    }

    var userName: String {
        return dataModel.firstName + " " + dataModel.lastName
    }

    var countTips: Int {
        return dataModel.tipsCount
    }

    var countPhotos: Int {
        return dataModel.photosCount
    }

    var countFollowers: Int {
        return getCountFollowers()
    }

    var userLists: String {
        return getUserLists()
    }

    func getUserPhotoLabel() -> String {
        return String(dataModel.firstName.first ?? " ")
    }
}

// MARK: - converting data from UserInfoDataModel to UserInfoViewModel
private extension UserInfoViewModel {

    func getCountFollowers() -> Int {
        return dataModel.followersCount.reduce(0, +)
    }

    func getUserLists() -> String {
        var listsName = String()
        dataModel.arrayOfListNames.forEach {
            listsName += "\($0), "
        }

        if listsName.hasSuffix(", ") {
            listsName.removeLast(2)
        }

        return listsName
    }
}
