//
//  TableViewCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 17.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import UIKit

class SearchTableCell: UITableViewCell {

    @IBOutlet private weak var venueNameLabel: UILabel!
    @IBOutlet private weak var venueAddressLabel: UILabel!
    @IBOutlet private weak var venueCategoryLabel: UILabel!

    static let identifier = "SearchTableCell"

    static func nib() -> UINib {
        return UINib(nibName: "SearchTableCell", bundle: nil)
    }

    func configure(venueName: String, address: [String], category: String?) {

        venueNameLabel.text = venueName
        var fullAddress = ""
        address.forEach {
            fullAddress += "\($0) "
        }
        venueAddressLabel.text = fullAddress

        guard let category = category else {
            return
        }

        venueCategoryLabel.text = category
    }
}
