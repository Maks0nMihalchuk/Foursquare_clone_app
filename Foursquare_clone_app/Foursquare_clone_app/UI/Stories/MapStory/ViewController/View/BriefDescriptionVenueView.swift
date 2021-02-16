//
//  BriefDescriptionVenue.swift
//  Foursquare_clone_app
//
//  Created by maks on 15.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class BriefDescriptionVenueView: UIView {

    @IBOutlet private weak var venueNameLabel: UILabel!
    @IBOutlet private weak var hoursStatusLabel: UILabel!

    func setup(withViewModel viewModel: ShortInfoViewModel?) {
        venueNameLabel.text = viewModel?.name
        hoursStatusLabel.text = viewModel?.hoursStatus
    }
}
