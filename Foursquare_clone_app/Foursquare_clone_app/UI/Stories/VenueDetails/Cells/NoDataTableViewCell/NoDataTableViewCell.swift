//
//  NoDataTableViewCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 28.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class NoDataTableViewCell: UITableViewCell {

    @IBOutlet weak var textErrorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        textErrorLabel.text = "NotDataTableViewCell.LabelText".localized()
    }
}
