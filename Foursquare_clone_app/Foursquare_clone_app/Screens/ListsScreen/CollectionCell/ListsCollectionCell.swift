//
//  CollectionViewCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class ListsCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var listNameLabel: UILabel!
    @IBOutlet private weak var numberPlacesLabel: UILabel!

    static let identifier = "ListsCollectionCell"

    static func nib() -> UINib {
        return UINib(nibName: "ListsCollectionCell", bundle: nil)
    }

    func configure (backgroundImageName: String = "listsCellBackground", userImageName: String = "userListsImage",
                    listName: String, numberPlaces: String = "No plasec") {
        backgroundImageView.image = UIImage(named: backgroundImageName)
        userImageView.image = UIImage(named: userImageName)
        listNameLabel.text = listName
        numberPlacesLabel.text = numberPlaces
    }

}
