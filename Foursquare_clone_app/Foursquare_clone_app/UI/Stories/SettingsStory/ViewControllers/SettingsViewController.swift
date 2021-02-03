//
//  SettingsViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func settingsViewController(_ viewController: SettingsViewController,
                                didTapBack button: UIBarButtonItem)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var pushNotificationsLabel: UILabel!
    @IBOutlet weak var aboutUsButton: UIButton!
    @IBOutlet weak var termsOfUseButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!

    private lazy var backButton: UIBarButtonItem = {
        let image = UIImage(named: "backWhiteArrow")
        let button = UIBarButtonItem(image: image, style: .plain, target: self,
                                     action: #selector(screenCloseButtonPressed(_:)))
        button.tintColor = .white
        return button
    }()

    weak var delegate: SettingsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }

    @IBAction func didTapAboutUsButton(_ sender: UIButton) {

    }

    @IBAction func didTapTermsOfUseButton(_ sender: UIButton) {

    }

    @IBAction func didTapPrivacyButton(_ sender: UIButton) {

    }
}

// MARK: - setup UI
private extension SettingsViewController {

    func setupNavigationBar() {
        let navBar = navigationController?.navigationBar
        title = "Settings.Title".localized()
        navigationItem.leftBarButtonItem = backButton
        navBar?.barTintColor = .systemBlue
        navBar?.backgroundColor = .systemBlue
        navBar?.barTintColor = .systemBlue
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white,
                                       .font: UIFont.boldSystemFont(ofSize: 22)]
    }

    func setupView() {
        pushNotificationsLabel.text = "Settings.PushNotification".localized()
        aboutUsButton.setTitle("Settings.AboutUs".localized(),
                               for: .normal)
        termsOfUseButton.setTitle("Settings.TermsOfUse".localized(),
                                  for: .normal)
        privacyButton.setTitle("Settings.Privacy".localized(),
                               for: .normal)
    }

    @objc func screenCloseButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.settingsViewController(self, didTapBack: sender)
    }
}
