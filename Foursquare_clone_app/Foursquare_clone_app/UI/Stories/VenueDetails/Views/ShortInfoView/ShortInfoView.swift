//
//  ShortInfoView.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class ShortInfoView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var addressVenueLabel: UILabel!
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var hoursVenueLabel: UILabel!
    @IBOutlet private weak var categoriesLabel: UILabel!
    @IBOutlet private weak var categoriesVenueLabel: UILabel!

    var viewModel: ShortInfoViewModel? {
        didSet {
            guard let requireViewModel = viewModel else { return }

            reloadUI(with: requireViewModel)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - setupUI
private extension ShortInfoView {

    func commonInit() {
        let nibName = String(describing: ShortInfoView.self)
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func setupUI() {
        ratingLabel.text = "-"
        addressLabel.text = "AdressLabelText".localized()
        addressVenueLabel.text = "LabelTextPlaceholder".localized()
        hoursLabel.text = "HoursLabelText".localized()
        hoursVenueLabel.text = "LabelTextPlaceholder".localized()
        categoriesLabel.text = "CategoriesLabelText".localized()
        categoriesVenueLabel.text = "LabelTextPlaceholder".localized()
    }

    func reloadUI(with viewModel: ShortInfoViewModel) {
        ratingLabel.text = viewModel.rating
        ratingLabel.backgroundColor = viewModel.ratingColor
        addressVenueLabel.text = viewModel.location
        hoursVenueLabel.text = viewModel.hoursStatus
        categoriesVenueLabel.text = viewModel.categories
    }
}
