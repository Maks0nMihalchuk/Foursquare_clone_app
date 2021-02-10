//
//  RedView.swift
//  Foursquare_clone_app
//
//  Created by maks on 10.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class RedView: UIView {

    @IBOutlet private weak var redViewLabel: UILabel!

    func setupUI() {
        redViewLabel.text = "RED_VIEW"
        self.backgroundColor = .systemRed
    }
}
