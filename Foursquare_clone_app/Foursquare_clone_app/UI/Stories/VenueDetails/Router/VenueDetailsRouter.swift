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

class VenueDetailsRouter: VenueDetailsRoutingProtocol {

    private var completion: VenueDetailsStoryCompletion?
    private var detailController: UIViewController?
    private let assembly: VenueDetailsAssemblyProtocol
    private let networking: NetworkManager
    private let mapRouter: MapRoutingProtocol = MapRouter(assembly: MapAssembly())

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

    private func showAlertError(_ viewController: UIViewController) {
        let alertTitle = "AlertTitle".localized(name: "DetailVCLocalization")
        let alertMessage = "AlertMessage".localized(name: "DetailVCLocalization")
        let alertActionTitle = "AlertActionTitle".localized(name: "DetailVCLocalization")
        let alertController = UIAlertController(title: alertTitle,
                                                message: alertMessage,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: alertActionTitle,
                                   style: .default,
                                   handler: nil)
        alertController.addAction(action)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - DetailViewControllerWithScrollViewDelegate

extension VenueDetailsRouter: ScrollViewDetailViewControllerDelegate {

    func scrollViewDetailViewController(_ viewController: ScrollViewDetailViewController,
                                        didTapBack button: UIButton) {
        finalizeStory()
    }

    func scrollViewDetailViewController(_ viewController: ScrollViewDetailViewController,
                                        didTapFullScreenImage button: UIButton,
                                        with image: UIImage,
                                        model: BestPhotoViewModel) {
        let fullScreenImage = assembly.assemblyFullScreenImageVC()

        fullScreenImage.venueImage = image
        fullScreenImage.venueName = model.venueName
        fullScreenImage.delegate = self

        viewController.navigationController?.pushViewController(fullScreenImage, animated: true)
    }

    func scrollViewDetailViewController(_ viewController: ScrollViewDetailViewController,
                                        didTapShowMap button: UIButton, with viewModel: ShortInfoViewModel) {
        mapRouter.showMapStory(from: viewController,
                               viewModel: viewModel,
                               animated: true) { (_) in
            self.mapRouter.hideMapStory(animated: true)
        }
    }

    func scrollViewDetailViewController(_ viewController: ScrollViewDetailViewController,
                                        didShowAlertError error: Bool) {
        showAlertError(viewController)
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

    func detailViewController(_ viewController: DetailViewController, didShowAlertError error: Bool) {
        showAlertError(viewController)
    }

    func detailViewController(_ viewController: DetailViewController,
                              didTapShowMap button: UIButton,
                              with viewModel: ShortInfoViewModel) {
        mapRouter.showMapStory(from: viewController,
                               viewModel: viewModel,
                               animated: true) { (_) in
            self.mapRouter.hideMapStory(animated: true)
        }
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
