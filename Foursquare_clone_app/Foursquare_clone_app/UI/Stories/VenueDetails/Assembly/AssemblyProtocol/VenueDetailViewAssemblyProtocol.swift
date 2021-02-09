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
    func assemblyBestPhotoView(containerBounds: CGRect) -> BestPhotoView
    func assemblyShortInfoView(containerBounds: CGRect) -> ShortInfoView
    func assemblyHoursView(containerBounds: CGRect) -> HoursView
    func assemblyContactView(containerBounds: CGRect) -> ContactView
}
