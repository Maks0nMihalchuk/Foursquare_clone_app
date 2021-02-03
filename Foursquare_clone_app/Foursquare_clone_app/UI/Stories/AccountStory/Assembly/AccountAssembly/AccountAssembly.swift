//
//  AccountAssembly.swift
//  Foursquare_clone_app
//
//  Created by maks on 02.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class AccountAssembly: AccountAssemblyProtocol {
    func assemblyAuthorizedUserView(containreBounds: CGRect) -> AuthorizedUserView {
        let view = AuthorizedUserView(frame: containreBounds)
        view.alpha = 0

        return view
    }

    func assemblyUnauthorizedUserView(containreBounds: CGRect) -> UnauthorizedUserView {
        let view = UnauthorizedUserView(frame: containreBounds)
        view.alpha = 0

        return view
    }
}
