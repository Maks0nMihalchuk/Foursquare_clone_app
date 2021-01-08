//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 07.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func cropCornerOfImage () -> UIImage {
        let path = UIBezierPath()
        let imageSize = self.size
        let scale: CGFloat = 0

        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)

        self.draw(at: .zero)

        let startingPoint = CGPoint(x: 0, y: imageSize.height)
        let intermediatePoint = CGPoint(x: 0, y: imageSize.height * 0.85)
        let finalPoint = CGPoint(x: imageSize.width + 10, y: imageSize.height)

        path.move(to: startingPoint)
        path.addLine(to: intermediatePoint)
        path.addLine(to: finalPoint)

        path.lineWidth = 2

        let color: UIColor = .white
        color.setFill()

        path.fill()

        UIRectClip(path.bounds)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }
        UIGraphicsEndImageContext()

        return image
    }
}
