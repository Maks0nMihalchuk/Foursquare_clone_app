//
//  ContactTableCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 16.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class ContactTableCell: UITableViewCell {

    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var webSiteLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var webSiteURLLabel: UILabel!

    static let identifier = "ContactTableCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        phoneLabel.text = "ContactTableCell.PhoneLabelText".localized()
        webSiteLabel.text = "ContactTableCell.WebSiteLabelText".localized()
    }

    static func nib () -> UINib {
        return UINib(nibName: "ContactTableCell", bundle: nil)
    }

    func configure (numberText: String, webSiteURL: String) {
        phoneNumberLabel.text = numberText
        webSiteURLLabel.text = webSiteURL
    }

}
