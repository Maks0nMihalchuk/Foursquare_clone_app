//
//  AccountAssembly.swift
//  Foursquare_clone_app
//
//  Created by maks on 02.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class AccountViewAssembly: AccountViewAssemblyProtocol {
    func assemblyAuthorizedUserView(containerBounds: CGRect) -> AuthorizedUserView {
        let view = AuthorizedUserView(frame: containerBounds)
        view.alpha = 0

        return view
    }

    func assemblyUnauthorizedUserView(containerBounds: CGRect) -> UnauthorizedUserView {
        let view = UnauthorizedUserView(frame: containerBounds)
        view.alpha = 0

        return view
    }
}
