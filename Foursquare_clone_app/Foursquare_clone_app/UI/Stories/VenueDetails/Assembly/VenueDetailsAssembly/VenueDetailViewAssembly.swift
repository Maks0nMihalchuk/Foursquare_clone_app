//
//  File.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class VenueDetailViewAssembly: VenueDetailViewAssemblyProtocol {

    func assemblyBestPhotoView(containerBounds: CGRect) -> BestPhotoView {
        let view = BestPhotoView(frame: containerBounds)
        return view
    }

    func assemblyShortInfoView(containerBounds: CGRect) -> ShortInfoView {
        let view = ShortInfoView(frame: containerBounds)
        return view
    }

    func assemblyHoursView(containerBounds: CGRect) -> HoursView {
        let view = HoursView(frame: containerBounds)
        return view
    }

    func assemblyContactView(containerBounds: CGRect) -> ContactView {
        let view = ContactView(frame: containerBounds)
        return view
    }
}
