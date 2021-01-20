//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 18.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

protocol GeneralLogicCellProtocol {
    static func getIdentifier() -> String
    static func getNib() -> UINib
}

// MARK: - GeneralLogicCellProtocol
extension UITableViewCell: GeneralLogicCellProtocol {
    static func getNib() -> UINib {
        return UINib(nibName: getIdentifier(),
                     bundle: nil)
    }

    static func getIdentifier() -> String {
        return String(describing: type(of: self.init()))
    }
}
