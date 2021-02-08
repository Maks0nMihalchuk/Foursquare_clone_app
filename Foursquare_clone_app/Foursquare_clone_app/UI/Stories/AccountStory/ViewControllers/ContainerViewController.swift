//
//  ContainerViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 02.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit
import SafariServices
import Security

enum AuthorizationState {
    case noAuthorization
    case yesAuthorization
}

class ContainerViewController: UIViewController {

    @IBOutlet private weak var navigationBarView: UIView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private let keychainManager = KeychainManager.shared
    private let networkManager = NetworkManager.shared
    private let redirectUrl = NetworkManager.shared.redirectUrl.lowercased()
    private let appearance = UITabBarAppearance()
    private var authorizationState: AuthorizationState?
    private let assembly = AccountViewAssembly()
    private var unauthorizedUserView: UnauthorizedUserView?
    private var authorizedUserView: AuthorizedUserView?
    private let router = SettingsRouting(assembly: SettingsAssembly())

    private var userInfoViewModel: UserInfoViewModel? {
        didSet {
            guard let requireViewModel = userInfoViewModel else { return }

            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }

                self.authorizedUserView?.viewModel = requireViewModel
                self.userNameLabel.text = requireViewModel.userName
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupAuthorizedUserView()
        setupUnauthorizedUserView()
        checkToken()
        showViewDependingOnState()
    }

    @IBAction func didTapSettingsButton(_ sender: UIButton) {
        router.showSettingsStory(from: self, animated: true) { (_) in
            self.router.hideSettingsStory(animated: true)
        }
    }
}

// MARK: - AuthorizedUserViewDelegate
extension ContainerViewController: AuthorizedUserViewDelegate {
    func authorizedUserView(_ authorizedUserView: AuthorizedUserView, didTapSignOutButton: UIButton) {
        keychainManager.removeValue(for: getKeyToToken())
        checkToken()
        showViewDependingOnState()
    }
}

// MARK: - UnauthorizedUserViewDelegate
extension ContainerViewController: UnauthorizedUserViewDelegate {
    func unauthorizedUserView(_ unauthorizedUserView: UnauthorizedUserView,
                              didTapSignInButton: UIButton) {
        networkManager.autorizationFoursquare { (url, isSuccessful) in
            if isSuccessful {
                guard let url = url else { return }

                DispatchQueue.main.async {
                    let safariViewController = SFSafariViewController(url: url)
                    safariViewController.delegate = self
                    self.present(safariViewController, animated: true, completion: nil)
                }
            } else {
                self.showErrorAlert()
            }
        }
    }
}

// MARK: - SFSafariViewControllerDelegate
extension ContainerViewController: SFSafariViewControllerDelegate {
    func safariViewController(_ controller: SFSafariViewController,
                              initialLoadDidRedirectTo URL: URL) {
        if URL.absoluteString.contains(redirectUrl) {
            dismiss(animated: true, completion: nil)
            let code = URL.valueOf("code")
            setupActivityIndicator(isLaunch: true)
            networkManager.getAccessToken(code: code) { (accessToken, isSuccessful) in
                if isSuccessful {

                    let dataAccessToken = accessToken?.data(using: .utf8)

                    DispatchQueue.main.async {
                        if self.keychainManager.saveValue(value: dataAccessToken,
                                                          with: self.getKeyToToken()) {
                            self.checkToken()
                            self.showViewDependingOnState()
                            self.setupActivityIndicator(isLaunch: false)
                        } else {
                            self.setupActivityIndicator(isLaunch: false)
                            self.showErrorAlert()
                        }
                    }
                } else {
                    self.setupActivityIndicator(isLaunch: false)
                    self.showErrorAlert()
                }
            }
        }
    }
}

// MARK: - getUserInfo
private extension ContainerViewController {

    func getUserInfo() {
        let token = keychainManager.getValue(for: getKeyToToken())
        networkManager.getUserInfo(accessToken: token) { (userInfo, isSuccessful) in
            if isSuccessful {
                guard let userInfo = userInfo else { return }

                DispatchQueue.main.async {
                    self.userInfoViewModel = UserInfoViewModel(dataModel: userInfo)
                    self.setupActivityIndicator(isLaunch: false)
                }
            } else {
                self.showErrorAlert()
            }
        }
    }
}

// MARK: - work with token
private extension ContainerViewController {

    func checkToken() {
        let tokenAvailability = keychainManager
            .checkForDataAvailability(for: getKeyToToken())
        authorizationState = tokenAvailability
            ? .yesAuthorization
            : .noAuthorization
    }

    func getKeyToToken() -> String {
        return KeychainKey.accessToken.currentKey
    }
}

// MARK: - setup view
private extension ContainerViewController {

    func showViewDependingOnState() {
        guard let state = authorizationState else { return }

        setupsettingButton(state: state)
        switch state {
        case .noAuthorization:
            setupActivityIndicator(isLaunch: false)
            authorizedUserView?.alpha = 0
            userNameLabel.text = "AccountViewController.YourProfile".localized()
            authorizedUserView?.removeFromSuperview()
            animatedSetupView(subview: unauthorizedUserView ?? UIView())
        case .yesAuthorization:
            unauthorizedUserView?.alpha = 0
            setupActivityIndicator(isLaunch: true)
            getUserInfo()
            unauthorizedUserView?.removeFromSuperview()
            animatedSetupView(subview: authorizedUserView ?? UIView())
        }
    }

    func animatedSetupView(subview: UIView) {
        let duration = 0.5
        UIView.animate(withDuration: duration) {
            self.containerView.addSubview(subview)
            subview.alpha = 1
        }
    }

    func setupActivityIndicator(isLaunch: Bool) {
        activityIndicator.isHidden = !isLaunch

        if isLaunch {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func setupAuthorizedUserView() {
        authorizedUserView = assembly.assemblyAuthorizedUserView(containerBounds: containerView.bounds)
        authorizedUserView?.delegate = self
    }

    func setupUnauthorizedUserView() {
        unauthorizedUserView = assembly.assemblyUnauthorizedUserView(containerBounds: containerView.bounds)
        unauthorizedUserView?.delegate = self
    }

    func setupTabBar() {
        appearance.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearance
    }

    func setupsettingButton(state: AuthorizationState) {
        let duration = 0.25
        UIView.animate(withDuration: duration) {
            switch state {
            case .noAuthorization:
                self.settingButton.alpha = 0
                self.settingButton.isEnabled = false
            case .yesAuthorization:
                self.settingButton.alpha = 1
                self.settingButton.isEnabled = true
            }
        }
    }

    func showErrorAlert() {
        let alertController = UIAlertController(title: "AlertErrorTitle".localized(),
                                                message: "AccountViewController.AlertMessage".localized(),
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "AccountViewController.AlertActionTitle".localized(),
                                   style: .default,
                                   handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
