//
//  UIViewExtension.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        let nibName = String(describing: T.self)
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! T
    }
}
