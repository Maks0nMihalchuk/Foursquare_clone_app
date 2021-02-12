//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

protocol VenueDetailViewAssemblyProtocol {
    func assemblyBestPhotoView() -> BestPhotoView
    func assemblyShortInfoView() -> ShortInfoView
    func assemblyHoursView() -> HoursView
    func assemblyContactView() -> ContactView
    func assemblyRedView() -> RedView
}
