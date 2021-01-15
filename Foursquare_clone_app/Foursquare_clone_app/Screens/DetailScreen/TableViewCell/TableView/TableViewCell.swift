//
//  TableViewCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 15.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var informationLabel: UILabel!

    static let identifier = "TableViewCell"

    static func nib () -> UINib {
        return UINib(nibName: "TableViewCell", bundle: nil)
    }

    func configure (itemName: String, information: String) {
        itemNameLabel.text = itemName
        informationLabel.text = information
    }
}
