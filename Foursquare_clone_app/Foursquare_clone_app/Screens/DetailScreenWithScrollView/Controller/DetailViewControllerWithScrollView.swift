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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

// MARK: - SetupUI
private extension DetailViewControllerWithScrollView {

    func setupUI() {

    }

    func reloadUI(with viewModel: String) {

    }
}

// MARK: - UI configuration
private extension DetailViewControllerWithScrollView {

    func configureShortInfo(viewModel: String) {

    }

    func configureBestPhotoContainerView(viewModel: String) {

    }

    func configureHoursContainer(viewModel: String) {

    }

    func configureContactsContainer(viewModel: String) {

    }
}
