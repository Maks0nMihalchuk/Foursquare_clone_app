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
        return dataModel.countTips
    }

    var countPhotos: Int {
        return dataModel.countPhotos
    }

    var countFollowers: Int {
        return getCountFollowers()
    }

    var userLists: String {
        return getUserLists()
    }

    func getUserPhotoLabel() -> String {
        switch dataModel.default {
        case true:
            return String(dataModel.firstName.first ?? " ")
        case false:
            return ""
        }
    }
}

// MARK: - converting data from UserInfoDataModel to UserInfoViewModel
private extension UserInfoViewModel {

    func getCountFollowers() -> Int {
        return dataModel.countFollowers.reduce(0, +)
    }

    func getUserLists() -> String {
        var listsName = String()
        dataModel.listsName.forEach {
            listsName += "\($0), "
        }

        if listsName.hasSuffix(", ") {
            listsName.removeLast(2)
        }

        return listsName
    }
}
