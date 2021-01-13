//
//  ListsButtonCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class CellWithButton: UICollectionViewCell {

    @IBOutlet private weak var createNewListLabel: UILabel!
    @IBOutlet private weak var addImageView: UIImageView!

    static let identifier = "CellWithButton"

    override func awakeFromNib() {
        createNewListLabel.text = "CellWithButton.CreateNewListLabelTitle".localized()
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }

    static func nib() -> UINib {
        return UINib(nibName: "CellWithButton", bundle: nil)
    }

}
