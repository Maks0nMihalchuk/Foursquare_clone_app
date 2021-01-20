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

    override func awakeFromNib() {
        super.awakeFromNib()
        adressLabel.text = "ShortInfoTableCell.AdressLabelText".localized()
        hoursLabel.text = "HoursLabelText".localized()
        categoriesLabel.text = "ShortInfoTableCell.CategoriesLabelText".localized()
    }

    func configure(with content: ShortInfoCellModel) {
        adressVenueLabel.text = content.adressVenue
        hoursVenueLabel.text = content.hoursVenue
        categoriesVenueLabel.text = content.categoriesVenue
        ratingLabel.text = content.rating
        ratingLabel.backgroundColor = content.ratingColor
    }
}
