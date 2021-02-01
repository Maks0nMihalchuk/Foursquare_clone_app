//
//  ImageTableCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 15.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit
    //нажал кнопку показа полноэкранного изображения
protocol ImageTableViewCellDelegate: class {
    func imageTableCell(_ tableViewCell: ImageTableViewCell,
                        didTapToShowFullScreenImage imageView: UIImageView, name: String)

}

class ImageTableViewCell: UITableViewCell {

    @IBOutlet private weak var venueImageView: UIImageView!
    @IBOutlet private weak var nameVenueLabel: UILabel!

    weak var delegate: ImageTableViewCellDelegate?

    private let gradient = CAGradientLayer()
    private var name = String()

    func configure(with viewModel: ImageCellViewModel, venueName: String) {
        venueImageView.image = viewModel.image
        gradientSetup()
        nameVenueLabel.text = viewModel.nameVenue
        name = venueName
    }
    @IBAction func fullScreenImageButtonPressed(_ sender: UIButton) {
        delegate?.imageTableCell(self, didTapToShowFullScreenImage: venueImageView, name: name)
    }
}

// MARK: - gradientSetup
private extension ImageTableViewCell {

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
