//
//  ImageScrollView.swift
//  Foursquare_clone_app
//
//  Created by maks on 17.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class ImageScrollView: UIScrollView {

    private var imageZoomView: UIImageView!
    private let defaultMinScale: CGFloat = 0.1
    private let customDefaultScale: CGFloat = 0.3
    private let defaultMiddleScale: CGFloat = 0.5
    private let defaultMaxScale: CGFloat = 1.0
    private let maxScale: CGFloat = 2.5
    private let defaultCoordinate: CGFloat = 0.0
    private let frameToCenterWidthDivisor: CGFloat = 2.0
    private let frameToCenterHeightDivisor: CGFloat = 3.0

    private lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self,
                                                action: #selector(handleTapGesture(_ :)))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()

    init(frame: CGRect, image: UIImage) {
        self.imageZoomView = UIImageView(image: image)
        super.init(frame: frame)
        setupScrollView()
        setupImageView()
        configureFor(imageSize: image.size)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        centerImage()
    }
}

// MARK: - UIScrollViewDelegate
extension ImageScrollView: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageZoomView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}

// MARK: - setup UI
private extension ImageScrollView {

    func setupScrollView() {
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        decelerationRate = .fast
    }

    func setupImageView() {
        addSubview(imageZoomView)
        imageZoomView.addGestureRecognizer(zoomingTap)
        imageZoomView.isUserInteractionEnabled = true
    }

    func configureFor(imageSize: CGSize) {
        contentSize = imageSize
        setCurrentMaxAndMinZoomScale()
        zoomScale = minimumZoomScale
    }
}

// MARK: - Image Position adjustment and setting maximum and minimum zoom
private extension ImageScrollView {

    func setCurrentMaxAndMinZoomScale() {
        let boundsSize = bounds.size
        let imageSize = imageZoomView.bounds.size

        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)

        var maxScale: CGFloat = defaultMaxScale

        if minScale < defaultMinScale {
            maxScale = customDefaultScale
        }
        if minScale >= defaultMinScale && minScale < defaultMiddleScale {
            maxScale = defaultMaxScale
        }
        if minScale >= defaultMiddleScale {
            maxScale = max(self.maxScale, minScale)
        }

        minimumZoomScale = minScale
        maximumZoomScale = maxScale
    }

    func centerImage() {
        var frameToCenter = imageZoomView.frame

        if frameToCenter.width < bounds.width {
            frameToCenter.origin.x = (bounds.width - frameToCenter.width)
                / frameToCenterWidthDivisor
        } else {
            frameToCenter.origin.x = defaultCoordinate
        }

        if frameToCenter.height < bounds.height {
            frameToCenter.origin.y = (bounds.height - frameToCenter.height)
                / frameToCenterHeightDivisor
        } else {
            frameToCenter.origin.y = defaultCoordinate
        }

        imageZoomView.frame = frameToCenter
    }
}

// MARK: - work with gesture
private extension ImageScrollView {

    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: gestureRecognizer.view)
        zoom(point: location, animated: true)
    }

    func zoom(point: CGPoint, animated: Bool) {
        let currectScale = zoomScale
        let minScale = minimumZoomScale
        let maxScale = maximumZoomScale

        guard !(minScale == maxScale && minScale > defaultMaxScale) else { return }

        let toScale = maxScale
        let finalScale = (currectScale == minScale) ? toScale : minScale
        let zoomRect = self.zoomRect(scale: finalScale, center: point)
        self.zoom(to: zoomRect, animated: animated)
    }

    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero

        zoomRect.size.width = bounds.width / scale
        zoomRect.size.height = bounds.height / scale

        zoomRect.origin.x = center.x - (zoomRect.width / frameToCenterWidthDivisor)
        zoomRect.origin.y = center.y - (zoomRect.height / frameToCenterHeightDivisor)
        return zoomRect
    }
}
