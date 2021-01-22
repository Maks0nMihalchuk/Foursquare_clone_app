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

    override func awakeFromNib() {
        super.awakeFromNib()
        phoneLabel.text = "PhoneLabelText".localized()
        webSiteLabel.text = "WebSiteLabelText".localized()
    }

    func configure(with content: ContactCellModel) {
        phoneNumberLabel.text = content.phone
        webSiteURLLabel.text = content.webSiteURL
    }

}
