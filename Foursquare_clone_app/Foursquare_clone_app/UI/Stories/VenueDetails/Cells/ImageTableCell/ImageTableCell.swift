//
//  ImageTableCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 15.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol ImageTableCellDelegate: class {
    func imageTableCell(_ tableViewCell: ImageTableCell,
                        didTapFullScreenImage button: UIButton,
                        with image: UIImage, _ name: String)

}

class ImageTableCell: UITableViewCell {

    @IBOutlet private weak var venueImageView: UIImageView!
    @IBOutlet private weak var nameVenueLabel: UILabel!

    weak var delegate: ImageTableCellDelegate?

    private let gradient = CAGradientLayer()
    private var name = String()

    func configure(with content: ImageCellModel, venueName: String) {
        venueImageView.image = content.image
        gradientSetup()
        nameVenueLabel.text = content.nameVenue
        name = venueName
    }
    @IBAction func fullScreenImageButtonPressed(_ sender: UIButton) {
        guard let image = venueImageView.image else { return }

        delegate?.imageTableCell(self, didTapFullScreenImage: sender, with: image, name)
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