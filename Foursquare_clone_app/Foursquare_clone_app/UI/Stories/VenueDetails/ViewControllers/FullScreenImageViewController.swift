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

    weak var delegate: FullScreenImageDelegate?

    var venueName = String()
    var venueImage: UIImage?

    private var imageScrollView: ImageScrollView!

    private lazy var backButton: UIBarButtonItem = {
        let image = UIImage(named: "backWhiteArrow")
        let button = UIBarButtonItem(image: image, style: .plain, target: self,
                                     action: #selector(screenCloseButtonPressed(_:)))
        button.tintColor = .white
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageScrollView()
        setupNavigationBar()
    }
}

// MARK: - setupUI
private extension FullScreenImageViewController {

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

    func setupImageScrollView() {
        guard let image = venueImage else { return }

        imageScrollView = ImageScrollView(frame: view.bounds, image: image)
        view.addSubview(imageScrollView)
        setupLayoutImageScrollView()
    }

    func setupLayoutImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

    @objc func screenCloseButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.fullScreenImageViewController(self, didTapBack: sender)
    }
}
