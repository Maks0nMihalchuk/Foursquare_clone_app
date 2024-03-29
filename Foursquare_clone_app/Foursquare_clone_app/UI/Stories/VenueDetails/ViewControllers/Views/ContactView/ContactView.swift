//
//  ContactView.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class ContactView: UIView {

    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var websiteLabel: UILabel!
    @IBOutlet private weak var phoneVenueLabel: UILabel!
    @IBOutlet private weak var websiteVenueLabel: UILabel!

    var viewModel: ContactViewModel? {
        didSet {
            guard let requireViewModel = viewModel else { return }

           reloadUI(with: requireViewModel)
        }
    }

    func setupUI() {
        phoneLabel.text = "PhoneLabelText".localized(name: "DetailVCLocalization")
        websiteLabel.text = "WebSiteLabelText".localized(name: "DetailVCLocalization")
        phoneVenueLabel.text = "LabelTextPlaceholder".localized(name: "DetailVCLocalization")
        websiteVenueLabel.text = "LabelTextPlaceholder".localized(name: "DetailVCLocalization")
    }

}

// MARK: - setupUI
private extension ContactView {

    func reloadUI(with viewModel: ContactViewModel) {
        phoneVenueLabel.text = viewModel.phone
        websiteVenueLabel.text = viewModel.website
    }
}
