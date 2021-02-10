//
//  HoursVIew.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class HoursView: UIView {

    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var hoursVanueLabel: UILabel!
    @IBOutlet private weak var detailDaysLabel: UILabel!
    @IBOutlet private weak var detailHoursLabel: UILabel!
    @IBOutlet private weak var detailHoursButton: UIButton!

    var viewModel: HoursViewModel? {
        didSet {
            guard let requireViewModel = viewModel else { return }

            reloadUI(with: requireViewModel)
        }
    }

    func setupUI() {
        hoursLabel.text = "HoursLabelText".localized()
        hoursVanueLabel.text = "LabelTextPlaceholder".localized()
        detailDaysLabel.text = "LabelTextPlaceholder".localized()
        detailHoursLabel.text = "LabelTextPlaceholder".localized()
    }

}

// MARK: - setupUI
private extension HoursView {

    func reloadUI(with viewModel: HoursViewModel) {
        hoursVanueLabel.text = viewModel.hoursStatus
        detailDaysLabel.text = viewModel.detailDays
        detailHoursLabel.text = viewModel.detailHours
    }
}
