//
//  HoursVIew.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

protocol HoursViewDelegate: class {
    func hoursView(_ view: HoursView,
                   didTapChangeStateButton button: UIButton,
                   detailHours stackView: UIStackView)
}

class HoursView: UIView {

    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var hoursVanueLabel: UILabel!
    @IBOutlet private weak var detailDaysLabel: UILabel!
    @IBOutlet private weak var detailHoursLabel: UILabel!
    @IBOutlet private weak var detailHoursButton: UIButton!
    @IBOutlet private weak var detailHoursStackView: UIStackView!

    var viewModel: HoursViewModel? {
        didSet {
            guard let requireViewModel = viewModel else { return }

            reloadUI(with: requireViewModel)
        }
    }

    weak var delegate: HoursViewDelegate?

    @IBAction func stateChangeButtonPressed(_ sender: UIButton) {
        delegate?.hoursView(self, didTapChangeStateButton: sender, detailHours: detailHoursStackView)
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
        checkForDataAvailability(with: viewModel)
        hoursVanueLabel.text = viewModel.hoursStatus
        detailDaysLabel.text = viewModel.detailDays
        detailHoursLabel.text = viewModel.detailHours
    }

    func checkForDataAvailability(with viewModel: HoursViewModel) {
        let defaultTest = "Add Hours".localized()

        if viewModel.hoursStatus != defaultTest {
            detailHoursButton.isHidden = false
        } else {
            detailHoursButton.isHidden = true
        }
    }
}
