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
    var detailConroller: UIViewController?

    init(assembly: VenueDetailsAssembly) {
        self.assembly = assembly
    }

    private let assembly: VenueDetailsAssembly

    func showVenueDetailsStory(from: UIViewController,
                               type: VenueDetailsStoryType,
                               model: ViewModel,
                               animated: Bool, completion: @escaping VenueDetailsStoryCompletion) {

        self.completion = completion

        switch type {
        case .tableView:
            let detailController = assembly.assemblyDetailWithTableViewVC()

            guard let controller = detailController else { return }

            controller.viewModel = model
            controller.delegate = self
            detailConroller = controller
            controller.modalPresentationStyle = .fullScreen
            from.present(controller, animated: animated, completion: nil)
        case .scrollView:
            let detailController = assembly.assemblyDetailWithScrollViewVC()

            guard let controller = detailController else { return }

            controller.delegate = self
            controller.viewModel = model
            let navigationController = UINavigationController(rootViewController: controller)
            detailConroller = controller
            navigationController.modalPresentationStyle = .fullScreen
            from.present(navigationController, animated: animated, completion: nil)
        }
    }

    func hideVenueDetailsStory(animated: Bool) {
        guard let controller = detailConroller else { return }

        controller.dismiss(animated: animated, completion: nil)
        detailConroller = nil
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
                                            with image: UIImage, model: ViewModel) {
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
                              didTapFullScreenImage button: UIButton,
                              with model: ViewModel) {

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
