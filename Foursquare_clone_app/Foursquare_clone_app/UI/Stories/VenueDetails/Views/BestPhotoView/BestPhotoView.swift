//
//  BestPhotoView.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit
import Kingfisher

class BestPhotoView: UIView {

    @IBOutlet private weak var bestPhotoImageView: UIImageView!
    @IBOutlet private weak var venueName: UILabel!

    private let gradient = CAGradientLayer()

    var viewModel: BestPhotoViewModel? {
        didSet {
            guard let requireViewModel = viewModel else { return }

            reloadUI(with: requireViewModel)
        }
    }

    func setupUI() {
        bestPhotoImageView.image = UIImage(named: "img_placeholder")
        gradientSetup()
        venueName.text = "LabelTextPlaceholder".localized()
    }

    func didTransferImage() -> UIImage? {
        return bestPhotoImageView.image
    }
}
private extension BestPhotoView {

    func reloadUI(with viewModel: BestPhotoViewModel) {
        bestPhotoImageView.kf.setImage(with: viewModel.imageURL,
                                       placeholder: UIImage(named: "img_placeholder"),
                                       options: [.transition(.fade(1.0))],
                                       progressBlock: nil)
        gradientSetup()
        venueName.text = viewModel.nameVenueAndPrice
    }

    func gradientSetup() {
        gradient.frame = bestPhotoImageView.bounds
        gradient.colors = [UIColor.black.withAlphaComponent(1.0).cgColor,
                           UIColor.black.withAlphaComponent(0.0).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.locations = [0, 0.75, 1]
        bestPhotoImageView.layer.addSublayer(gradient)
    }
}
