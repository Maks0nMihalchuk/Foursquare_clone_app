//
//  ListsButtonCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class ListsButtonCell: UICollectionViewCell {

    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var createNewListLabel: UILabel!

    static let identifier = "ListsButtonCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }

    static func nib() -> UINib {
        return UINib(nibName: "ListsButtonCell", bundle: nil)
    }

}
