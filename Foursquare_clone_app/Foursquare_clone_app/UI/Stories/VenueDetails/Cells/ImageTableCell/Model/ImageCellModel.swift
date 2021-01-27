//
//  ImageTableCellModel.swift
//  Foursquare_clone_app
//
//  Created by maks on 18.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

struct ImageCellModel {
    let imageURL: URL?
    var image: UIImage? {
        return getImage()
    }
    let nameVenue: String
}

// MARK: - getImage
private extension ImageCellModel {

    func getImage() -> UIImage? {
        let imageView = UIImageView()
        imageView.kf.setImage(with: imageURL,
                              placeholder: UIImage(named: "img_placeholder"),
                              options: [.transition(.fade(1.0))],
                              progressBlock: nil)
        return imageView.image
    }
}
