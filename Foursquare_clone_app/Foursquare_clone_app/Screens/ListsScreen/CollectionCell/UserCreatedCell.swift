//
//  CollectionViewCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class UserCreatedCell: UICollectionViewCell {

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var listNameLabel: UILabel!
    @IBOutlet private weak var numberPlacesLabel: UILabel!

    static let identifier = "UserCreatedCell"

    static func nib() -> UINib {
        return UINib(nibName: "UserCreatedCell", bundle: nil)
    }

    func configure(backgroundImage: Data?,
                   userImageName: String,
                   listName: String,
                   numberPlaces: String) {

        if let imageData = backgroundImage {
            backgroundImageView.image = UIImage(data: imageData)?
                .cropCornerOfImage(by: .bottomLeftCorner)
                .cropCornerOfImage(by: .upperRightCorner)
        } else {
            backgroundImageView.image = UIImage(named: "listsCellBackground")?
                .cropCornerOfImage(by: .bottomLeftCorner)
                .cropCornerOfImage(by: .upperRightCorner)
        }

        userImageView.image = UIImage(named: userImageName)
        listNameLabel.text = listName
        numberPlacesLabel.text = numberPlaces
    }
}
