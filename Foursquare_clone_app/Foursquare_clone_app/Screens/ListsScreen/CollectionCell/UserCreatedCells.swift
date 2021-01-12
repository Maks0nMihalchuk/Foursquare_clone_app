//
//  CollectionViewCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class UserCreatedCells: UICollectionViewCell {

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var listNameLabel: UILabel!
    @IBOutlet private weak var numberPlacesLabel: UILabel!

    static let identifier = "UserCreatedCells"

    static func nib() -> UINib {
        return UINib(nibName: "UserCreatedCells", bundle: nil)
    }

    func configure (backgroundImage: Data?,
                    userImageName: String,
                    listName: String,
                    numberPlaces: String = "UserCreatedCells.NumberPlacesLabel".localized()) {
        
        if let imageData = backgroundImage {
            backgroundImageView.image = UIImage(data: imageData)?.cropCornerOfImage()
        } else {
            backgroundImageView.image = UIImage(named: "listsCellBackground")?.cropCornerOfImage()
        }

        userImageView.image = UIImage(named: userImageName)
        listNameLabel.text = listName

        if numberPlaces != "0" {
            numberPlacesLabel.text = "\(numberPlaces) " + "UserCreatedCells.Places".localized()
        } else {
            numberPlacesLabel.text = "UserCreatedCells.NumberPlacesLabel".localized()
        }

    }

}
