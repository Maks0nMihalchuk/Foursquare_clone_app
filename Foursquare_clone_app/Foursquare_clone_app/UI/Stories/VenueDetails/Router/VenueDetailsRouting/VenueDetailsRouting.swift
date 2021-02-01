//
//  VenueDetailsRouting.swift
//  Foursquare_clone_app
//
//  Created by maks on 26.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class VenueDetailsRouting: VenueDetailsRoutingProtocol {

    var completion: VenueDetailsStoryCompletion?
    var detailController: UIViewController?

    init(assembly: VenueDetailsAssembly, networking: NetworkManager) {
        self.assembly = assembly
        self.networking = networking
    }

    private let assembly: VenueDetailsAssembly
    private let networking: NetworkManager

    func showVenueDetailsStory(from: UIViewController,
                               type: VenueDetailsStoryType,
                               venueID: String,
                               animated: Bool, completion: @escaping VenueDetailsStoryCompletion) {

        self.completion = completion

        switch type {
        case .tableView:
            let detailController = assembly.assemblyDetailWithTableViewVC()

            guard let controller = detailController else { return }

            controller.venueID = venueID
            controller.networking = networking
            controller.delegate = self
            let navigationController = UINavigationController(rootViewController: controller)
            self.detailController = controller
            navigationController.modalPresentationStyle = .fullScreen
            from.present(navigationController, animated: animated, completion: nil)
        case .scrollView:
            let detailController = assembly.assemblyDetailWithScrollViewVC()

            guard let controller = detailController else { return }

            controller.venueID = venueID
            controller.networking = networking
            controller.delegate = self
            let navigationController = UINavigationController(rootViewController: controller)
            self.detailController = controller
            navigationController.modalPresentationStyle = .fullScreen
            from.present(navigationController, animated: animated, completion: nil)
        }
    }

    func hideVenueDetailsStory(animated: Bool) {
        guard let controller = detailController else { return }

        controller.dismiss(animated: animated, completion: nil)
        detailController = nil
    }

    private func finalizeStory() {
        self.completion?(.userCancelation)
        completion = nil
    }
}

// MARK: - DetailViewControllerWithScrollViewDelegate
extension VenueDetailsRouting: DetailViewControllerWithScrollViewDelegate {
    func detailViewControllerWithScrollView(_ viewController: DetailViewControllerWithScrollView,
                                            didTapBack button: UIButton) {
        finalizeStory()
    }

    func detailViewControllerWithScrollView(_ viewController: DetailViewControllerWithScrollView,
                                            didTapFullScreenImage button: UIButton,
                                            with image: UIImage, model: DetailViewModel) {
        let fullScreenImage = assembly.assemblyFullScreenImageVC()

        guard let imageScreen = fullScreenImage else { return }

        imageScreen.venueImage = image
        imageScreen.venueName = model.venueName
        imageScreen.delegate = self

        viewController.navigationController?.pushViewController(imageScreen, animated: true)
    }
}

// MARK: - DetailViewControllerDelegate
extension VenueDetailsRouting: DetailViewControllerDelegate {
    func detailViewController(_ viewController: DetailViewController,
                              didTapToShowFullScreenImage imageView: UIImageView,
                              name: String) {
        let fullScreenImage = assembly.assemblyFullScreenImageVC()

        guard let imageScreen = fullScreenImage else { return }

        imageScreen.venueImage = imageView.image
        imageScreen.venueName = name
        imageScreen.delegate = self

        viewController.navigationController?.pushViewController(imageScreen, animated: true)
    }

    func detailViewController(_ viewController: DetailViewController, didTapBack button: UIButton) {
        finalizeStory()
    }
}

// MARK: - FullScreenImageDelegate
extension VenueDetailsRouting: FullScreenImageDelegate {
    func fullScreenImageViewController(_ viewController: FullScreenImageViewController,
                                       didTapBack button: UIBarButtonItem) {

        viewController.navigationController?.popViewController(animated: true)
        viewController.navigationController?.isNavigationBarHidden = true
    }
}
