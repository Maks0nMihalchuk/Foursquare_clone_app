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

    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var haveAccountLabel: UILabel!
    @IBOutlet private weak var createYourPersonalAccLabel: UILabel!
    @IBOutlet private weak var signinButton: UIButton!

    weak var delegate: UnauthorizedUserViewDelegate?

    func setupUI() {
        placeholderLabel.text = "Unauthorized.PlaceholderLabel".localized()
        createYourPersonalAccLabel.text = "Unauthorized.createYourAcc".localized()
        haveAccountLabel.text = "Unauthorized.Already".localized()
        signinButton.setTitle("Unauthorized.SignInButton".localized(),
                              for: .normal)
    }

    @IBAction private func signInButtonPressed(_ sender: UIButton) {
        delegate?.unauthorizedUserView(self, didTapSignInButton: sender)
    }
}
