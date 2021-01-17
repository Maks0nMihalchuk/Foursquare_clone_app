//
//  TableViewCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 15.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class ShortInfoTableCell: UITableViewCell {

    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var adressLabel: UILabel!
    @IBOutlet private weak var adressVenueLabel: UILabel!
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var hoursVenueLabel: UILabel!
    @IBOutlet private weak var categoriesLabel: UILabel!
    @IBOutlet private weak var categoriesVenueLabel: UILabel!

    static let identifier = "ShortInfoTableCell"

    static func nib () -> UINib {
        return UINib(nibName: "ShortInfoTableCell", bundle: nil)

    }

    func configure (adressVenue: String, hoursVenue: String,
                    categoriesVenue: String, rating: String, ratingColor: UIColor) {
        adressVenueLabel.text = adressVenue
        hoursVenueLabel.text = hoursVenue
        categoriesVenueLabel.text = categoriesVenue
        ratingLabel.text = rating
        ratingLabel.backgroundColor = ratingColor
    }
}
