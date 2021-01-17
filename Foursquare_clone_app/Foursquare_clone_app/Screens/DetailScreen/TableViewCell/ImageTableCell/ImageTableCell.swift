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
    @IBOutlet private weak var nameVenueLabel: UILabel!
    @IBOutlet private weak var shortDescriptionLabel: UILabel!

    static let identifier = "ImageTableCell"

    static func nib () -> UINib {
        return UINib(nibName: "ImageTableCell", bundle: nil)
    }

    func configure (imageData: Data?, nameVenue: String, shortDescription: String) {

        if let image = imageData {

            venueImageView.image = UIImage(data: image)
        } else {
            venueImageView.image = UIImage(named: "unknown")
        }

        nameVenueLabel.text = nameVenue
        shortDescriptionLabel.text = shortDescription
    }

}
