//
//  UIColorExtension.swift
//  Foursquare_clone_app
//
//  Created by maks on 17.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        var color: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&color)

        let mask = 0x000000FF
        let red = Int(color >> 16) & mask
        let green = Int(color >> 8) & mask
        let blue = Int(color) & mask

        let redRGB   = CGFloat(red) / 255.0
        let greenRGB = CGFloat(green) / 255.0
        let blueRGB  = CGFloat(blue) / 255.0

        self.init(red: redRGB, green: greenRGB, blue: blueRGB, alpha: alpha)
    }
}
