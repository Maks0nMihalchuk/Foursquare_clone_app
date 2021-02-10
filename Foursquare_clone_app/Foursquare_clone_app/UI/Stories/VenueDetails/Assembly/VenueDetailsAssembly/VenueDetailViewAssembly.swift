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

    func assemblyBestPhotoView() -> BestPhotoView {
        let view = UIView.fromNib() as BestPhotoView
        view.setupUI()
        return view
    }

    func assemblyShortInfoView() -> ShortInfoView {
        let view = UIView.fromNib() as ShortInfoView
        view.setupUI()

        return view
    }

    func assemblyHoursView() -> HoursView {
        let view = UIView.fromNib() as HoursView
        view.setupUI()

        return view
    }

    func assemblyContactView() -> ContactView {
        let view = UIView.fromNib() as ContactView
        view.setupUI()

        return view
    }
}
