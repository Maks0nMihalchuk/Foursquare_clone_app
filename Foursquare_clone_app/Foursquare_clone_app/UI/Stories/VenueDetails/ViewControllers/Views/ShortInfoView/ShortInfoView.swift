//
//  ShortInfoView.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol ShortInfoViewDelegate: class {
    func shortInfoView(_ view: ShortInfoView,
                       didTapShowMapButton button: UIButton, with model: ShortInfoViewModel)
}

class ShortInfoView: UIView {

    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var addressVenueLabel: UILabel!
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var hoursVenueLabel: UILabel!
    @IBOutlet private weak var categoriesLabel: UILabel!
    @IBOutlet private weak var categoriesVenueLabel: UILabel!
    @IBOutlet private weak var showMapButton: UIButton!

    var viewModel: ShortInfoViewModel? {
        didSet {
            guard let requireViewModel = viewModel else { return }

            reloadUI(with: requireViewModel)
        }
    }

    weak var delegate: ShortInfoViewDelegate?

    func setupUI() {
        ratingLabel.text = "-"
        addressLabel.text = "AdressLabelText".localized(name: "DetailVCLocalization")
        addressVenueLabel.text = "LabelTextPlaceholder".localized(name: "DetailVCLocalization")
        hoursLabel.text = "HoursLabelText".localized(name: "DetailVCLocalization")
        hoursVenueLabel.text = "LabelTextPlaceholder".localized(name: "DetailVCLocalization")
        categoriesLabel.text = "CategoriesLabelText".localized(name: "DetailVCLocalization")
        categoriesVenueLabel.text = "LabelTextPlaceholder".localized(name: "DetailVCLocalization")
        showMapButton.setTitle("ShowMap".localized(name: "DetailVCLocalization"), for: .normal)
        showMapButton.titleLabel?.textAlignment = .center
    }

    @IBAction func didTapShowMapButton(_ sender: UIButton) {
        guard let model = viewModel else { return }

        delegate?.shortInfoView(self, didTapShowMapButton: sender, with: model)
    }
}

// MARK: - setupUI
private extension ShortInfoView {

    func reloadUI(with viewModel: ShortInfoViewModel) {
        ratingLabel.text = viewModel.rating
        ratingLabel.backgroundColor = viewModel.ratingColor
        addressVenueLabel.text = viewModel.location
        hoursVenueLabel.text = viewModel.hoursStatus
        categoriesVenueLabel.text = viewModel.categories
    }
}
