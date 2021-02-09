//
//  ListsRouting.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class ListsRouting: ListsRoutingProtocol {

    private let assembly: ListsAssemblyProtocol

    init(assembly: ListsAssemblyProtocol) {
        self.assembly = assembly
    }

    func showListsStory(from: inout UIViewController, animated: Bool) {
        let listsController = assembly.assemblyListsViewController()

        guard let controller = listsController else { return }

        controller.delegate = self
        controller.title = "ListsViewController.Title".localized()
        if from is UINavigationController {

            guard let navigationController = from as? UINavigationController else { return }

            navigationController.viewControllers = [controller]
        } else {
            from = controller
        }
    }
}

// MARK: - ListsViewControllerDelegate
extension ListsRouting: ListsViewControllerDelegate {

    func listsViewController(_ viewController: ListsViewController,
                             didTapSetupAlert alert: inout CreateNewListAlert!) {
        let alertID = String(describing: CreateNewListAlert.self)
        alert = Bundle.main.loadNibNamed(alertID,
                                         owner: viewController,
                                         options: nil)?.first as? CreateNewListAlert

        viewController.view.addSubview(alert)
        alert.center = viewController.view.center
        alert.delegate = viewController
    }

    func listsViewController(_ viewController: ListsViewController,
                             didShowAlert alert: CreateNewListAlert!,
                             visualEffectView: UIVisualEffectView,
                             scale: CGFloat,
                             duration: Double) {
        alert.transform = CGAffineTransform(scaleX: scale, y: scale)
        alert.alpha = 0

        UIView.animate(withDuration: duration) {
            visualEffectView.alpha = 1
            alert.alpha = 1
            alert.transform = CGAffineTransform.identity
        }
    }

    func listsViewController(_ viewController: ListsViewController,
                             didHideAlert alert: CreateNewListAlert!,
                             visualEffectView: UIVisualEffectView,
                             scale: CGFloat,
                             duration: Double) {
        UIView.animate(withDuration: duration) {
            visualEffectView.alpha = 0
            alert.alpha = 0
            alert.transform = CGAffineTransform(scaleX: scale, y: scale)
            alert.removeFromSuperview()
        }

    }

    func listsViewController(_ viewController: ListsViewController,
                             didTapCreateNewListWith parameters: (name: String?,
                                                                  description: String?,
                                                                  flag: Bool),
                             token: String) {
        guard
            let listName = parameters.name,
            let listDescription = parameters.description
            else { return }

        if !listName.isEmpty {
            viewController.startAnimationForAlert(key: .hide)
            NetworkManager.shared.postRequestForCreateNewList(token: token,
                                                              listName: listName,
                                                              descriptionList: listDescription,
                                                              collaborativeFlag: parameters.flag)
        }
    }
}
