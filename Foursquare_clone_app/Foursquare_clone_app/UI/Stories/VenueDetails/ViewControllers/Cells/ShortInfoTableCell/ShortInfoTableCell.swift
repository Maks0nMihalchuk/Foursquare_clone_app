//
//  TableViewCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 15.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol ShortInfoTableCellDelegate: class {
    func shortInfoTableCell(_ cell: ShortInfoTableCell,
                            didTapShowMapButton button: UIButton)
}

class ShortInfoTableCell: UITableViewCell {

    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var adressLabel: UILabel!
    @IBOutlet private weak var adressVenueLabel: UILabel!
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var hoursVenueLabel: UILabel!
    @IBOutlet private weak var categoriesLabel: UILabel!
    @IBOutlet private weak var categoriesVenueLabel: UILabel!
    @IBOutlet private weak var showMapViewButton: UIButton!

    weak var delegate: ShortInfoTableCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        adressLabel.text = "AdressLabelText".localized(name: "DetailVCLocalization")
        hoursLabel.text = "HoursLabelText".localized(name: "DetailVCLocalization")
        categoriesLabel.text = "CategoriesLabelText".localized(name: "DetailVCLocalization")
        showMapViewButton.setTitle("ShowMap".localized(name: "DetailVCLocalization"),
                             for: .normal)
        showMapViewButton.titleLabel?.textAlignment = .center
    }

    func configure(with content: ShortInfoCellModel) {
        adressVenueLabel.text = content.adressVenue
        hoursVenueLabel.text = content.hoursVenue
        categoriesVenueLabel.text = content.categoriesVenue
        ratingLabel.text = content.rating
        ratingLabel.backgroundColor = content.ratingColor
    }

    @IBAction func didTapShowMapButton(_ sender: UIButton) {
        delegate?.shortInfoTableCell(self, didTapShowMapButton: sender)
    }

}
