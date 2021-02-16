//
//  AuthorizedUserView.swift
//  Foursquare_clone_app
//
//  Created by maks on 02.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol AuthorizedUserViewDelegate: class {
    func authorizedUserView(_ authorizedUserView: AuthorizedUserView,
                            didTapSignOutButton: UIButton)
}

class AuthorizedUserView: UIView {

    @IBOutlet private weak var userPhotoImageView: UIImageView!
    @IBOutlet private weak var numberOfTipsLabel: UILabel!
    @IBOutlet private weak var tipsLabel: UILabel!
    @IBOutlet private weak var numberOfPhotoLabel: UILabel!
    @IBOutlet private weak var photosLabel: UILabel!
    @IBOutlet private weak var numberOfFollowersLabel: UILabel!
    @IBOutlet private weak var followersLabel: UILabel!
    @IBOutlet private weak var listLabel: UILabel!
    @IBOutlet private weak var userListsLabel: UILabel!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var signOutButton: UIButton!

    private lazy var defaultUserPhotoView: DefaultUserPhotoView = {
        let view = DefaultUserPhotoView(frame: self.userPhotoImageView.bounds,
                                        userName: "")
        return view
    }()

    weak var delegate: AuthorizedUserViewDelegate?

    var viewModel: UserInfoViewModel? {
        didSet {
            guard let requireViewModel = viewModel else { return }

            self.reloadUI(with: requireViewModel)
        }
    }

    func setupUI() {
        tipsLabel.text = "Authorized.Tips".localized(name: "AccountVCLocalization")
        photosLabel.text = "Authorized.Photos".localized(name: "AccountVCLocalization")
        followersLabel.text = "Authorized.Followers".localized(name: "AccountVCLocalization")
        listLabel.text = "Authorized.Lists".localized(name: "AccountVCLocalization")
        placeholderLabel.text = "Authorized.Placeholder".localized(name: "AccountVCLocalization")
        signOutButton.setTitle("Authorized.SignOutButton".localized(name: "AccountVCLocalization"),
                               for: .normal)
    }

    @IBAction private func didTapSignOutButton(_ sender: UIButton) {
        delegate?.authorizedUserView(self, didTapSignOutButton: sender)
    }
}

// MARK: - configureUI
private extension AuthorizedUserView {

    func reloadUI(with viewModel: UserInfoViewModel) {
        numberOfTipsLabel.text = "\(viewModel.countTips)"
        numberOfPhotoLabel.text = "\(viewModel.countPhotos)"
        numberOfFollowersLabel.text = "\(viewModel.countFollowers)"
        userListsLabel.text = "\(viewModel.userLists)"
        defaultUserPhotoView.userNameText = viewModel.getUserPhotoLabel()
        userPhotoImageView.addSubview(defaultUserPhotoView)
    }

}
