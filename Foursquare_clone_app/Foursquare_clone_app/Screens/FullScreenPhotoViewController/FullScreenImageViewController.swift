//
//  FullScreenImageViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 24.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!

    var venueName = String()
    var venueImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func screenCloseButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - setupUI
private extension FullScreenImageViewController {

    func setupNavigationController() {
        let navBar = navigationController?.navigationBar
        title = venueName

        navBar?.barTintColor = .black
        navBar?.backgroundColor = .black
        navBar?.barTintColor = .black
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white,
                                      .font: UIFont.boldSystemFont(ofSize: 22)]
    }

    func setupImageView() {
        imageView.image = venueImage
    }
}
