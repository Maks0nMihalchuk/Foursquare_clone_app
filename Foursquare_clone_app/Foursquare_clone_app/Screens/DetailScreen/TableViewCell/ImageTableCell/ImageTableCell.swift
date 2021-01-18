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

    static let identifier = "ImageTableCell"
    private let gradient = CAGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        gradientSetup()
        venueImageView.layer.addSublayer(gradient)
    }

    static func nib () -> UINib {
        return UINib(nibName: "ImageTableCell", bundle: nil)
    }

    func configure (imageData: Data?, nameVenue: String, shortDescription: String) {

        if let image = imageData {

            venueImageView.image = UIImage(data: image)
        } else {
            venueImageView.image = UIImage(named: "unknown")
        }

        nameVenueLabel.text = nameVenue + "\n \(shortDescription)"
    }

}
private extension ImageTableCell {
    func gradientSetup () {
        gradient.frame = venueImageView.bounds
        gradient.colors = [UIColor.black.withAlphaComponent(1.0).cgColor,
                           UIColor.black.withAlphaComponent(0.0).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.locations = [0, 0.75, 1]
    }
}
