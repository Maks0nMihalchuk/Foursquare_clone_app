//
//  HeaderCollectionView.swift
//  Foursquare_clone_app
//
//  Created by maks on 06.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class HeaderCollectionView: UICollectionReusableView {

    @IBOutlet private weak var titleForHeader: UILabel!

    static let identifier = "HeaderCollectionView"

    static func nib() -> UINib {
        return UINib(nibName: "HeaderCollectionView", bundle: nil)
    }

    func configure(title: String) {
            titleForHeader.text = title

    }
}
