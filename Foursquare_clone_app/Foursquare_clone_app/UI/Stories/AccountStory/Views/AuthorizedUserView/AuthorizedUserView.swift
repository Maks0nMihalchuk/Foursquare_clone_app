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

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var userPhotoImageView: UIImageView!
    @IBOutlet private weak var numberOfTipsLabel: UILabel!
    @IBOutlet private weak var tipsLabel: UILabel!
    @IBOutlet private weak var numberOfPhotoLabel: UILabel!
    @IBOutlet private weak var photoLabel: UILabel!
    @IBOutlet private weak var numberOfFollowersLabel: UILabel!
    @IBOutlet private weak var followersLabel: UILabel!
    @IBOutlet private weak var listsLabel: UILabel!
    @IBOutlet private weak var userListsLabel: UILabel!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction private func didTapSignOutButton(_ sender: UIButton) {
        delegate?.authorizedUserView(self, didTapSignOutButton: sender)
    }
}

// MARK: - setupUI
private extension AuthorizedUserView {
    func commonInit() {
        let nibName = String(describing: AuthorizedUserView.self)
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func setupUI() {
        tipsLabel.text = "Authorized.Tips".localized()
        photoLabel.text = "Authorized.Photos".localized()
        followersLabel.text = "Authorized.Followers".localized()
        listsLabel.text = "Authorized.Lists".localized()
        placeholderLabel.text = "Authorized.Placeholder".localized()
        signOutButton.setTitle("Authorized.SignOutButton".localized(),
                               for: .normal)
    }

    func reloadUI(with viewModel: UserInfoViewModel) {
        numberOfTipsLabel.text = "\(viewModel.countTips)"
        numberOfPhotoLabel.text = "\(viewModel.countPhotos)"
        numberOfFollowersLabel.text = "\(viewModel.countFollowers)"
        userListsLabel.text = "\(viewModel.userLists)"
        defaultUserPhotoView.userNameText = viewModel.getUserPhotoLabel()
        userPhotoImageView.addSubview(defaultUserPhotoView)
    }

}
