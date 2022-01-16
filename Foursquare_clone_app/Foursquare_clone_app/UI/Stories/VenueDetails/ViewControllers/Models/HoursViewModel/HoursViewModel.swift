//
//  HoursViewModel.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation

enum HoursTableCallState {
    case folded
    case decomposed
}

struct HoursViewModel {

    private let dataModel: DetailVenueModel

    init(dataModel: DetailVenueModel) {
        self.dataModel = dataModel
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

// MARK: - converting data from DetailVenueModel to HoursViewModel
private extension HoursViewModel {

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
}
