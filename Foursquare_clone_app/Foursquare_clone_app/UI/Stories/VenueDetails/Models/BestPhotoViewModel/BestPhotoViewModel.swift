//
//  BestPhotoViewModel.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

struct BestPhotoViewModel {
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
}

// MARK: - converting data from DetailVenueModel to BestPhotoViewModel
private extension BestPhotoViewModel {

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
