//
//  SettingsViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit
import UserNotifications

protocol SettingsViewControllerDelegate: class {
    func settingsViewController(_ viewController: SettingsViewController,
                                didChangeValue sender: UISwitch)
    func settingsViewController(_ viewController: SettingsViewController,
                                didTapBack button: UIBarButtonItem)
    func settingsViewController(_ viewController: SettingsViewController,
                                didTapAboutUs button: UIButton,
                                with urlString: String)
    func settingsViewController(_ viewController: SettingsViewController,
                                didTapTermsOfUse button: UIButton,
                                with fileName: String)
    func settingsViewController(_ viewController: SettingsViewController,
                                didTapPrivacy button: UIButton)
}

class SettingsViewController: UIViewController {

    @IBOutlet private weak var pushNotificationsLabel: UILabel!
    @IBOutlet private weak var aboutUsButton: UIButton!
    @IBOutlet private weak var termsOfUseButton: UIButton!
    @IBOutlet private weak var privacyButton: UIButton!

    private let notificationCenter = UNUserNotificationCenter.current()
    private let urlString = "https://www.apple.com"
    private var fileName = String()

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

    @IBAction func didChangeSwitchValue(_ sender: UISwitch) {
        delegate?.settingsViewController(self, didChangeValue: sender)
    }

    @IBAction func didTapAboutUsButton(_ sender: UIButton) {
        delegate?.settingsViewController(self, didTapAboutUs: sender, with: urlString)
    }

    @IBAction func didTapTermsOfUseButton(_ sender: UIButton) {
        fileName = "АК2"
        delegate?.settingsViewController(self,
                                         didTapTermsOfUse: sender, with: fileName)
    }

    @IBAction func didTapPrivacyButton(_ sender: UIButton) {
        delegate?.settingsViewController(self, didTapPrivacy: sender)
    }
}

// MARK: - setup UI
private extension SettingsViewController {

    func setupNavigationBar() {
        let navBar = navigationController?.navigationBar
        title = "Title".localized(name: "SettingsVCLocalization")
        navigationItem.leftBarButtonItem = backButton
        navBar?.barTintColor = .systemBlue
        navBar?.backgroundColor = .systemBlue
        navBar?.barTintColor = .systemBlue
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white,
                                       .font: UIFont.boldSystemFont(ofSize: 22)]
    }

    func setupView() {
        pushNotificationsLabel.text = "PushNotification"
            .localized(name: "SettingsVCLocalization")
        aboutUsButton.setTitle("AboutUs"
            .localized(name: "SettingsVCLocalization"),
                               for: .normal)
        termsOfUseButton.setTitle("TermsOfUse"
            .localized(name: "SettingsVCLocalization"),
                                  for: .normal)
        privacyButton.setTitle("Privacy"
            .localized(name: "SettingsVCLocalization"),
                               for: .normal)
    }

    @objc func screenCloseButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.settingsViewController(self, didTapBack: sender)
    }
}
