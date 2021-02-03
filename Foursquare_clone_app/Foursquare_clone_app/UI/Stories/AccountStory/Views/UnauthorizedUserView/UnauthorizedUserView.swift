//
//  UnauthorizedUserView.swift
//  Foursquare_clone_app
//
//  Created by maks on 02.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol UnauthorizedUserViewDelegate: class {
    func unauthorizedUserView(_ unauthorizedUserView: UnauthorizedUserView,
                              didTapSignInButton: UIButton)
}

class UnauthorizedUserView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var haveAccountLabel: UILabel!
    @IBOutlet private weak var createYourPersonalAccLabel: UILabel!
    @IBOutlet private weak var signinButton: UIButton!

    weak var delegate: UnauthorizedUserViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupView()
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }

    @IBAction private func signInButtonPressed(_ sender: UIButton) {
        delegate?.unauthorizedUserView(self, didTapSignInButton: sender)
    }
}

// MARK: - setupUI
private extension UnauthorizedUserView {
    func commonInit() {
        let nibName = String(describing: UnauthorizedUserView.self)
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func setupView() {
        placeholderLabel.text = "Unauthorized.PlaceholderLabel".localized()
        createYourPersonalAccLabel.text = "Unauthorized.createYourAcc".localized()
        haveAccountLabel.text = "Unauthorized.Already".localized()
        signinButton.setTitle("Unauthorized.SignInButton".localized(),
                              for: .normal)
    }
}
