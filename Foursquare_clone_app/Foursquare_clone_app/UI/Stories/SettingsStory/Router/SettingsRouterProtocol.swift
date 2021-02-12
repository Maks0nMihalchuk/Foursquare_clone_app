//
//  SettingsRouterProtocol.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

typealias SettingsStoryCompletion = ((_ result: SettingsStoryResult) -> Void)

protocol SettingsRouterProtocol {
    func showSettingsStory(from: UIViewController,
                           animated: Bool,
                           completion: @escaping SettingsStoryCompletion)
    func hideSettingsStory(animated: Bool)
}
