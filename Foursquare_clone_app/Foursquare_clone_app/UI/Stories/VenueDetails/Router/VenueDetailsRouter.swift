//
//  VenueDetailsRouting.swift
//  Foursquare_clone_app
//
//  Created by maks on 26.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

enum VenueDetailsStoryType {
    case tableView
    case scrollView
}

enum VenueDetailsStoryResult {
    case success
    case userCancelation
    case failure(error: Error?)
}

class VenueDetailsRouter: VenueDetailsRouterProtocol {

    private var completion: VenueDetailsStoryCompletion?
    private var detailController: UIViewController?
    private let assembly: VenueDetailsAssemblyProtocol
    private let networking: NetworkManager

    init(assembly: VenueDetailsAssemblyProtocol, networking: NetworkManager) {
        self.assembly = assembly
        self.networking = networking
    }

    func showVenueDetailsStory(from: UIViewController,
                               type: VenueDetailsStoryType,
                               venueID: String,
                               animated: Bool, completion: @escaping VenueDetailsStoryCompletion) {

        self.completion = completion

        switch type {
        case .tableView:
            let detailController = assembly.assemblyDetailWithTableViewVC()

            detailController.venueID = venueID
            detailController.networking = networking
            detailController.delegate = self
            let navigationController = UINavigationController(rootViewController: detailController)
            self.detailController = detailController
            navigationController.modalPresentationStyle = .fullScreen
            from.present(navigationController, animated: animated, completion: nil)
        case .scrollView:
            let detailController = assembly.assemblyDetailWithScrollViewVC()

            detailController.venueID = venueID
            detailController.networking = networking
            detailController.delegate = self
            let navigationController = UINavigationController(rootViewController: detailController)
            self.detailController = detailController
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
extension VenueDetailsRouter: DetailViewControllerWithScrollViewDelegate {
    func detailViewControllerWithScrollView(_ viewController: DetailViewControllerWithScrollView,
                                            didTapBack button: UIButton) {
        finalizeStory()
    }

    func detailViewControllerWithScrollView(_ viewController: DetailViewControllerWithScrollView,
                                            didTapFullScreenImage button: UIButton,
                                            with image: UIImage,
                                            model: DetailViewModel) {
        let fullScreenImage = assembly.assemblyFullScreenImageVC()

        fullScreenImage.venueImage = image
        fullScreenImage.venueName = model.venueName
        fullScreenImage.delegate = self

        viewController.navigationController?.pushViewController(fullScreenImage, animated: true)
    }
}

// MARK: - DetailViewControllerDelegate
extension VenueDetailsRouter: DetailViewControllerDelegate {
    func detailViewController(_ viewController: DetailViewController,
                              didTapToShowFullScreenImage imageView: UIImageView,
                              name: String) {
        let fullScreenImage = assembly.assemblyFullScreenImageVC()

        fullScreenImage.venueImage = imageView.image
        fullScreenImage.venueName = name
        fullScreenImage.delegate = self

        viewController.navigationController?.pushViewController(fullScreenImage, animated: true)
    }

    func detailViewController(_ viewController: DetailViewController, didTapBack button: UIButton) {
        finalizeStory()
    }
}

// MARK: - FullScreenImageDelegate
extension VenueDetailsRouter: FullScreenImageDelegate {
    func fullScreenImageViewController(_ viewController: FullScreenImageViewController,
                                       didTapBack button: UIBarButtonItem) {

        viewController.navigationController?.popViewController(animated: true)
        viewController.navigationController?.isNavigationBarHidden = true
    }
}
