//
//  ListsViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class ListsViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    private var alertToCreateNewList: AlertToCreateNewList!

    private let defaultNamesForLists = defaultNameLists
    private let defaultHeaderLists = listOfHeaderNames
    private var infoAboutUserLists = [GetUserListsGroup]()
    private let networkManager = NetworkManager.shared
    private let keychainManager = KeychainManager.shared
    private let numberOfCellsInRow = 2
    private let numberOfHorizontalIndents: CGFloat = 3
    private let numberOfVerticalIndents: CGFloat = 2
    private let offset: CGFloat = 10

    private let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lists"
        getInfoAboutUserLists()
        setupCollectionCells()
        setupVisualEffectView()
    }

    private func setupCollectionCells () {
        collectionView.register(UserCreatedCells.nib(),
                                forCellWithReuseIdentifier: UserCreatedCells.identifier)
        collectionView.register(ListsButtonCell.nib(), forCellWithReuseIdentifier: ListsButtonCell.identifier)
        collectionView.register(HeaderCollectionView.nib(),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionView.identifier)
    }

    private func setupVisualEffectView () {
        view.addSubview(visualEffectView)
        visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.alpha = 0
    }

    private func showAlert () {
        alertToCreateNewList.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        alertToCreateNewList.alpha = 0

        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.alertToCreateNewList.alpha = 1
            self.alertToCreateNewList.transform = CGAffineTransform.identity
        }
    }

    private func hideAlert () {
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.alpha = 0
            self.alertToCreateNewList.alpha = 0
            self.alertToCreateNewList.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.alertToCreateNewList.removeFromSuperview()
        }
    }

    private func setupAlert () {
        alertToCreateNewList = Bundle.main.loadNibNamed("AlertToCreateNewList",
                                                        owner: self,
                                                        options: nil)?.first as? AlertToCreateNewList
        view.addSubview(alertToCreateNewList)
        alertToCreateNewList.center = view.center
        alertToCreateNewList.configureAlertImage()
        alertToCreateNewList.delegate = self
        alertToCreateNewList.connectDelegateForTextFields()
    }

    private func checkForAuthorization () -> Bool {

        return keychainManager.checkForDataAvailability(for: getTokenKey())
    }

    private func getTokenKey () -> String {
        return KeychainKey.accessToken.currentKey
    }

    private func getToken () -> String {
        return keychainManager.getValue(for: getTokenKey())
    }

    private func getInfoAboutUserLists () {
        networkManager.getInfoAboutUserLists(token: getToken()) { (userLists) in
            print("networkManager")
            guard let userLists = userLists else {
                return
            }
            DispatchQueue.main.async {
                self.infoAboutUserLists = userLists
                self.collectionView.reloadData()
            }
        }
    }

}
extension ListsViewController: AlertDelegate {
    func closeButtonPressed (cancelButton: UIButton) {
        hideAlert()
    }

    func createListButtonPressed (buttonCreate: UIButton) {
        let listName = configureListOptions[KeyForList.listName.currentKey] as? String

        guard let name = listName else {
            return
        }

        if !name.isEmpty {
            hideAlert()
            print("POST request")
        } else {
            return
        }
    }

    func collaborationSwitchAcrion(colloboraticeSwitch: UISwitch) {
        if colloboraticeSwitch.isOn {
            configureListOptions[KeyForList.collaborative.currentKey] = colloboraticeSwitch.isOn
        } else {
            configureListOptions[KeyForList.collaborative.currentKey] = false
        }

    }
}
extension ListsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let numberOfUserLists = infoAboutUserLists[indexPath.section].items.count

        if infoAboutUserLists.isEmpty {
            if indexPath.section == 1 {
                setupAlert()
                showAlert()
            }
        } else {
            if indexPath.item == numberOfUserLists {
                setupAlert()
                showAlert()
            } else {
            // action
            }

        }
    }

}
extension ListsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if infoAboutUserLists.isEmpty {
            return 2
        } else {
            return infoAboutUserLists.count
        }

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if section == 0 {

            if infoAboutUserLists.isEmpty {
                return defaultNamesForLists.count
            } else {
                return infoAboutUserLists[section].count
            }

        } else {

            if infoAboutUserLists.isEmpty {
                return 1
            } else {
                return infoAboutUserLists[section].count + 1
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard
            let header = collectionView
                .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                              withReuseIdentifier: HeaderCollectionView.identifier,
                                              for: indexPath) as? HeaderCollectionView else {
            return UICollectionReusableView()
        }
        if infoAboutUserLists.isEmpty {
            if indexPath.section == 0 {
                header.configure(title: defaultHeaderLists[indexPath.section].title,
                                 type: defaultHeaderLists[indexPath.section].type,
                                 numberOfLists: nil)
            } else {
                header.configure(title: defaultHeaderLists[indexPath.section].title,
                                 type: defaultHeaderLists[indexPath.section].type,
                                 numberOfLists: nil)
            }
        } else {

            let title = infoAboutUserLists[indexPath.section].name
            let type = infoAboutUserLists[indexPath.section].type
            let numberOfLists = infoAboutUserLists[indexPath.section].count
            header.configure(title: title, type: type, numberOfLists: numberOfLists)
        }

        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let optionDefaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCreatedCells.identifier,
                                                                   for: indexPath) as? UserCreatedCells

        guard let cell = optionDefaultCell else {
            return UICollectionViewCell()
        }

        let addButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: ListsButtonCell.identifier,
                                                               for: indexPath)

        if infoAboutUserLists.isEmpty {

            if indexPath.section == 0 {
                cell.configure(userImageName: defaultImageForLists[indexPath.item],
                               listName: defaultNamesForLists[indexPath.item].listName)
                return cell
            } else {

                if indexPath.item == 0 {
                    return addButtonCell
                } else {
                    return UICollectionViewCell()
                }

            }
        } else {
            let numberOfUserLists = infoAboutUserLists[indexPath.section].items.count
            if indexPath.section != 0 && indexPath.item == numberOfUserLists {
                return addButtonCell
            }

            let listName = infoAboutUserLists[indexPath.section].items[indexPath.item].name
            let numberPlaces = infoAboutUserLists[indexPath.section].items[indexPath.item].listItems.count

            cell.configure(backgroundImageName: "listsCellBackground",
                           userImageName: userImageDefault,
                           listName: listName,
                           numberPlaces: "\(numberPlaces)")
            return cell
        }
    }

}
extension ListsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let topBottomPadding = offset * numberOfVerticalIndents

        let collectionViewBounds = collectionView.bounds
        let widthCell = collectionViewBounds.width / CGFloat(numberOfCellsInRow)
        let heightCell: CGFloat = widthCell
        let spacing = (numberOfHorizontalIndents) * offset / CGFloat(numberOfCellsInRow)

        return CGSize(width: widthCell - spacing, height: heightCell - topBottomPadding)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 35)
    }
}
