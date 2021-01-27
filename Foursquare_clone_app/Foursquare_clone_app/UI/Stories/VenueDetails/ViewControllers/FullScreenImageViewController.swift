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
    private let router = VenueDetailsRouting(assembly: VenueDetailsAssembly())

    private lazy var backButton: UIBarButtonItem = {
        let image = UIImage(named: "backWhiteArrow")
        let button = UIBarButtonItem(image: image, style: .plain, target: self,
                                     action: #selector(screenCloseButtonPressed(_:)))
        button.tintColor = .white
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        setupNavigationController()
    }
}

// MARK: - setupUI
private extension FullScreenImageViewController {

    func setupNavigationController() {
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
        guard let image = venueImage else { return }
        imageView.image = image
    }

    @objc func screenCloseButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.fullScreenImageViewController(self, didTapBack: sender)
    }
}
