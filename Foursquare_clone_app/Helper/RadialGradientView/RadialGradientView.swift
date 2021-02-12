//
//  RadialGradientView.swift
//  Foursquare_clone_app
//
//  Created by maks on 27.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

@IBDesignable
class RadialGradientView: UIView {
    @IBInspectable var insideColor: UIColor = .clear
    @IBInspectable var outsideColor: UIColor = .clear
    private let divider: CGFloat = 1.8

    override func draw(_ rect: CGRect) {
        let colors = [insideColor.cgColor, outsideColor.cgColor] as CFArray
        let endRadius = min(frame.width, frame.height) / divider
        let centerX = bounds.size.width / 2
        let centerY = bounds.size.height / 2
        let center = CGPoint(x: centerX, y: centerY)

        let cgGradient = CGGradient(colorsSpace: nil, colors: colors, locations: [0, 1])
        let currentContext = UIGraphicsGetCurrentContext()

        guard
            let gradient = cgGradient,
            let context = currentContext
        else { return }

        context.drawRadialGradient(gradient,
                                   startCenter: center,
                                   startRadius: 0.0,
                                   endCenter: center,
                                   endRadius: endRadius,
                                   options: CGGradientDrawingOptions.drawsAfterEndLocation)
    }
}
