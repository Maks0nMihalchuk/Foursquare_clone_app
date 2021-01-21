//
//  ViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 21.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class DetailViewControllerWithScrollView: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var venueNameLabel: UILabel!

    @IBOutlet private weak var staticAddressLabel: UILabel!
    @IBOutlet private weak var staticHoursStatusLabel: UILabel!
    @IBOutlet private weak var staticCategoryLabel: UILabel!

    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var addressVenueLabel: UILabel!
    @IBOutlet private weak var hoursStatusVenueLabel: UILabel!
    @IBOutlet private weak var categoriesVenueLabel: UILabel!

    @IBOutlet private weak var staticHoursLabel: UILabel!
    @IBOutlet private weak var hoursVenueLabel: UILabel!
    @IBOutlet private weak var detailDaysVenueLabel: UILabel!
    @IBOutlet private weak var detailHoursVenueLabel: UILabel!
    @IBOutlet private weak var detailHoursInfoButton: UIButton!
    @IBOutlet private weak var detailInfoStackView: UIStackView!

    @IBOutlet private weak var staticPhoneLabel: UILabel!
    @IBOutlet private weak var staticWebsiteLabel: UILabel!
    @IBOutlet private weak var phoneVenueLabel: UILabel!
    @IBOutlet private weak var websiteVenueLabel: UILabel!

    var viewModel: ViewModel? {
        didSet {
            guard let requireViewModel = viewModel else {
                return
            }

            DispatchQueue.main.async {
                guard self.isViewLoaded else {
                    return
                }

                self.reloadUI(with: requireViewModel)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - SetupUI
private extension DetailViewControllerWithScrollView {

    func setupUI() {
        imageView.image = UIImage(named: "img_placeholder")
        venueNameLabel.text = "LabelTextPlaceholder".localized()
        staticAddressLabel.text = "AdressLabelText".localized()
        staticHoursStatusLabel.text = "HoursLabelText".localized()
        staticCategoryLabel.text = "CategoriesLabelText".localized()
        staticHoursLabel.text = "HoursLabelText".localized()
        staticPhoneLabel.text = "PhoneLabelText".localized()
        staticWebsiteLabel.text = "WebSiteLabelText".localized()
        addressVenueLabel.text = "LabelTextPlaceholder".localized()
        ratingLabel.text = "-"
        hoursStatusVenueLabel.text = "LabelTextPlaceholder".localized()
        categoriesVenueLabel.text = "LabelTextPlaceholder".localized()
        hoursVenueLabel.text = "LabelTextPlaceholder".localized()
        detailHoursVenueLabel.text = "LabelTextPlaceholder".localized()
        detailDaysVenueLabel.text = "LabelTextPlaceholder".localized()
        phoneVenueLabel.text = "LabelTextPlaceholder".localized()
        websiteVenueLabel.text = "LabelTextPlaceholder".localized()
    }

    func reloadUI(with viewModel: ViewModel) {

    }
}

// MARK: - UI configuration
private extension DetailViewControllerWithScrollView {

    func configureBestPhotoContainerView(viewModel: ViewModel) {
        imageView.image = UIImage(data: viewModel.imageData)
        venueNameLabel.text = viewModel.nameVenueAndPrice
    }

    func configureShortInfo(viewModel: ViewModel) {
        addressVenueLabel.text = viewModel.location
        ratingLabel.text = viewModel.rating
        ratingLabel.backgroundColor = viewModel.ratingColor
        hoursStatusVenueLabel.text = viewModel.hoursStatus
        categoriesVenueLabel.text = viewModel.categories
    }

    func configureHoursContainer(viewModel: ViewModel) {
        hoursVenueLabel.text = viewModel.hoursStatus
        detailDaysVenueLabel.text = viewModel.detailDays
        detailHoursVenueLabel.text = viewModel.detailHours
    }

    func configureContactsContainer(viewModel: ViewModel) {
        phoneVenueLabel.text = viewModel.phone
        websiteVenueLabel.text = viewModel.website
    }
}
