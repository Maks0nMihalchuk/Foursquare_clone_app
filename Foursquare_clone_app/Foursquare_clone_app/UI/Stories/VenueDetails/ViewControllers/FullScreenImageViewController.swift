//
//  FullScreenImageViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 24.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol FullScreenImageDelegate: class {
    func fullScreenImageViewController(_ viewController: FullScreenImageViewController,
                                       didTapBack button: UIBarButtonItem)
}

class FullScreenImageViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!

    weak var delegate: FullScreenImageDelegate?

    var venueName = String()
    var venueImage: UIImage?
    private let pinchGestureRecognizer = UIPinchGestureRecognizer()
    private var pinchGestureAnchorScale: CGFloat?

    private var scale: CGFloat = 1.0 {
        didSet {
            updateImageViewTransform()
        }
    }

    private lazy var backButton: UIBarButtonItem = {
        let image = UIImage(named: "backWhiteArrow")
        let button = UIBarButtonItem(image: image, style: .plain, target: self,
                                     action: #selector(screenCloseButtonPressed(_:)))
        button.tintColor = .white
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupGestureRecognizer()
        setupImageView()
    }
}

// MARK: - setupUI
private extension FullScreenImageViewController {

    func setupGestureRecognizer() {
        pinchGestureRecognizer.addTarget(self, action: #selector(handlePinchGesture(_:)))
    }

    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        let navBar = navigationController?.navigationBar
        navigationItem.leftBarButtonItem = backButton
        title = venueName
        navBar?.barTintColor = .black
        navBar?.backgroundColor = .black
        navBar?.barTintColor = .black
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white,
                                       .font: UIFont.boldSystemFont(ofSize: 22)]
    }

    func setupImageView() {
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(pinchGestureRecognizer)

        guard let image = venueImage else { return }

        imageView.image = image
    }

    func updateImageViewTransform() {
        imageView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale).rotated(by: 0.0)
    }

    @objc func handlePinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard pinchGestureRecognizer === gestureRecognizer else { return }

        switch gestureRecognizer.state {
        case .began:
            pinchGestureAnchorScale = gestureRecognizer.scale
        case .changed:
            guard let pinchGestureAnchorScale = pinchGestureAnchorScale else { return }

            let gestureScale = gestureRecognizer.scale
            scale += gestureScale - pinchGestureAnchorScale
            self.pinchGestureAnchorScale = gestureScale
        case .cancelled, .ended:
            pinchGestureAnchorScale = nil
        case .failed, .possible:
            break
        default: break
        }
    }

    @objc func screenCloseButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.fullScreenImageViewController(self, didTapBack: sender)
    }
}
