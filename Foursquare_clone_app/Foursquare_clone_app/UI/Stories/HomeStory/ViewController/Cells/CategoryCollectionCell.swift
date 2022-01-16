//
//  StandardCategoryCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 14.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var categoryImage: UIImageView!
    @IBOutlet private weak var categotyLabel: UILabel!

    static let identifier = "CategoryCollectionCell"

    static func nib() -> UINib {
        return UINib(nibName: "CategoryCollectionCell", bundle: nil)
    }

    func configure(imageName: String, categoryTitle: String) {
        categoryImage.image = UIImage(named: imageName)
        categotyLabel.text = categoryTitle
    }
}
