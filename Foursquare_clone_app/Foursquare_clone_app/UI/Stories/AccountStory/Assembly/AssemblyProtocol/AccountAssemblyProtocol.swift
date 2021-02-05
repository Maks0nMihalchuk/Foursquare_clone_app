//
//  AccountProtocol.swift
//  Foursquare_clone_app
//
//  Created by maks on 02.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

protocol AccountAssemblyProtocol {
    func assemblyAuthorizedUserView(containerBounds: CGRect) -> AuthorizedUserView
    func assemblyUnauthorizedUserView(containerBounds: CGRect) -> UnauthorizedUserView
}
