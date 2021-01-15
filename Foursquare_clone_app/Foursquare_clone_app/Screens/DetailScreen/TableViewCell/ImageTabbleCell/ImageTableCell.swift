//
//  ImageTableCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 15.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class ImageTableCell: UITableViewCell {

    @IBOutlet private weak var venueImageView: UIImageView!
    @IBOutlet weak var nameVenueLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!

    static let identifier = "ImageTableCell"

    static func nib () -> UINib {
        return UINib(nibName: "ImageTableCell", bundle: nil)
    }

    func configure (imageData: String, nameVenue: String, shortDescription: String) {
        venueImageView.image = UIImage(named: imageData)
        nameVenueLabel.text = nameVenue
        shortDescriptionLabel.text = shortDescription
    }
}
