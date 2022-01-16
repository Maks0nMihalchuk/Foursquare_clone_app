//
//  ListsRouting.swift
//  Foursquare_clone_app
//
//  Created by maks on 08.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class ListsRouter: ListsRoutingProtocol {

    private let assembly: ListsAssemblyProtocol

    init(assembly: ListsAssemblyProtocol) {
        self.assembly = assembly
    }

    func showListsStory(from: inout UIViewController, animated: Bool) {
        let listsController = assembly.assemblyListsViewController()

        listsController.delegate = self
        listsController.title = "Title".localized(name: "ListVCLocalization")
        if from is UINavigationController {

            guard let navigationController = from as? UINavigationController else { return }

            navigationController.viewControllers = [listsController]
        } else {
            from = listsController
        }
    }
}

// MARK: - ListsViewControllerDelegate
extension ListsRouter: ListsViewControllerDelegate {

    func listsViewController(_ viewController: ListsViewController,
                             didTapSetupAlertView view: UIView!,
                             with heightConstraint: NSLayoutConstraint!) {
        let alert = assembly.assemblyCreateNewListAlert()
        alert.translatesAutoresizingMaskIntoConstraints = false
        alert.delegate = viewController
        view.addSubview(alert)

        heightConstraint.constant = alert.bounds.height

        NSLayoutConstraint.activate([
            alert.topAnchor.constraint(equalTo: view.topAnchor),
            alert.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            alert.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alert.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func listsViewController(_ viewController: ListsViewController,
                             didShowAlertView view: UIView!,
                             visualEffectView: UIVisualEffectView,
                             scale: CGFloat,
                             duration: Double) {
        view.transform = CGAffineTransform(scaleX: scale, y: scale)
        view.alpha = 0

        UIView.animate(withDuration: duration) {
            visualEffectView.alpha = 1
            view.alpha = 1
            view.transform = CGAffineTransform.identity
        }
    }

    func listsViewController(_ viewController: ListsViewController,
                             didHideAlertView view: UIView!,
                             visualEffectView: UIVisualEffectView,
                             scale: CGFloat,
                             duration: Double) {
        UIView.animate(withDuration: duration) {
            visualEffectView.alpha = 0
            view.alpha = 0
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
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
