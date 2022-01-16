//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 07.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

enum KeyForCropCorner {
    case bottomLeftCorner
    case upperRightCorner
}

extension UIImage {
    func cropCornerOfImage (by key: KeyForCropCorner) -> UIImage {
        let path = UIBezierPath()
        let imageSize = self.size
        let scale: CGFloat = 0

        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)

        self.draw(at: .zero)

        var startingPoint: CGPoint
        var intermediatePoint: CGPoint
        var finalPoint: CGPoint
        var color: UIColor
        switch key {
        case .bottomLeftCorner:
            startingPoint = CGPoint(x: 0, y: imageSize.height)
            intermediatePoint = CGPoint(x: 0, y: imageSize.height * 0.85)
            finalPoint = CGPoint(x: imageSize.width + 10, y: imageSize.height)

            color = .white
        case .upperRightCorner:
           startingPoint = CGPoint(x: imageSize.width * 0.65, y: 0)
           intermediatePoint = CGPoint(x: imageSize.width, y: imageSize.height * 0.5)
           finalPoint = CGPoint(x: imageSize.width, y: 0)

           color = .blue
        }

        color.setFill()

        path.move(to: startingPoint)
        path.addLine(to: intermediatePoint)
        path.addLine(to: finalPoint)

        path.lineWidth = 2

        path.fill()

        UIRectClip(path.bounds)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }
        UIGraphicsEndImageContext()

        return image
    }
}
