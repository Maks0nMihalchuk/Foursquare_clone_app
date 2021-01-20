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

    private let gradient = CAGradientLayer()

    func configure(with content: ImageCellModel) {
        if let image = content.imageData {
            venueImageView.image = UIImage(data: image)
        } else {
            venueImageView.image = UIImage(named: "img_placeholder")
        }
        gradientSetup()
        nameVenueLabel.text = content.nameVenue + "\n \(content.shortDescription)"
    }

}

// MARK: - gradientSetup
private extension ImageTableCell {

    func gradientSetup() {
        gradient.frame = venueImageView.bounds
        gradient.colors = [UIColor.black.withAlphaComponent(1.0).cgColor,
                           UIColor.black.withAlphaComponent(0.0).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.locations = [0, 0.75, 1]
        venueImageView.layer.addSublayer(gradient)
    }
}
