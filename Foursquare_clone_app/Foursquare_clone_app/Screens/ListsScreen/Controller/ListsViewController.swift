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
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

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

    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ListsViewController.Title".localized()
        collectionView.refreshControl = refreshControl
        getInfoAboutUserLists()
        setupCollectionCells()
        setupVisualEffectView()
    }

    @objc private func refresh (sender: UIRefreshControl) {
        getInfoAboutUserLists()
        sender.endRefreshing()
        collectionView.reloadData()
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

    private func setupAlertForAddingNewList () {
        alertToCreateNewList = Bundle.main.loadNibNamed("AlertToCreateNewList",
                                                        owner: self,
                                                        options: nil)?.first as? AlertToCreateNewList
        view.addSubview(alertToCreateNewList)
        alertToCreateNewList.center = view.center
        alertToCreateNewList.configureAlert()
        alertToCreateNewList.delegate = self
        alertToCreateNewList.connectDelegateForTextFields()
    }

    private func setupAndShowErrorAlert () {
        let controller = UIAlertController(title: "AlertErrorTitle".localized(),
                                           message: "ListsViewController.AlertToErrorMessage".localized(),
                                           preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancel)
        present(controller, animated: true, completion: nil)
    }

    private func setupActivityIndicator (isHidden: Bool) {
        activityIndicator.isHidden = !isHidden

        if isHidden {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    private func showAlertAddingNewList () {
        alertToCreateNewList.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        alertToCreateNewList.alpha = 0

        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.alertToCreateNewList.alpha = 1
            self.alertToCreateNewList.transform = CGAffineTransform.identity
        }
    }

    private func hideAlertAddingNewList () {
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.alpha = 0
            self.alertToCreateNewList.alpha = 0
            self.alertToCreateNewList.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.alertToCreateNewList.removeFromSuperview()
        }
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
        if checkForAuthorization() {
            setupActivityIndicator(isHidden: checkForAuthorization())
            networkManager.getInfoAboutUserLists(token: getToken()) { (userLists, isSuccessful) in
                if isSuccessful {
                    guard let userLists = userLists else {
                        return
                    }

                    DispatchQueue.main.async {
                        self.infoAboutUserLists = userLists
                        self.setupActivityIndicator(isHidden: !self.checkForAuthorization())
                        self.collectionView.reloadData()
                    }
                } else {
                    self.setupActivityIndicator(isHidden: !self.checkForAuthorization())
                }

            }
        }
    }
}
extension ListsViewController: AlertDelegate {
    func closeButtonPressed (cancelButton: UIButton) {
        hideAlertAddingNewList()
    }

    func createListButtonPressed (buttonCreate: UIButton) {
        let listName = configureListOptions[KeyForList.listName.currentKey] as? String

        guard let name = listName else {
            return
        }

        if !name.isEmpty {
            hideAlertAddingNewList()
            networkManager.postRequestForCreateNewList(token: getToken())
        } else {
            return
        }
    }

    func collaborationSwitchAction(colloboraticeSwitch: UISwitch) {
        if colloboraticeSwitch.isOn {
            configureListOptions[KeyForList.collaborative.currentKey] = colloboraticeSwitch.isOn
        } else {
            configureListOptions[KeyForList.collaborative.currentKey] = false
        }

    }
}
extension ListsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if infoAboutUserLists.isEmpty {
            if indexPath.section == 1 {
                setupAndShowErrorAlert()
            } else {
                print("You clicked on a cell in the list")
            }
        } else {
            let numberOfUserLists = infoAboutUserLists[indexPath.section].items.count

            if indexPath.item == numberOfUserLists {
                setupAlertForAddingNewList()
                showAlertAddingNewList()
            } else {
                print("You clicked on a cell in the list")
            }

        }
    }

}
extension ListsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if section == 0 {
            return defaultNamesForLists.count
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
                                              for: indexPath) as? HeaderCollectionView
        else {
            return UICollectionReusableView()
        }

        if infoAboutUserLists.isEmpty {

            header.configure(title: defaultHeaderLists[indexPath.section].title,
                             type: defaultHeaderLists[indexPath.section].type,
                             numberOfLists: nil)
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
        let addButtonCell = collectionView.dequeueReusableCell(withReuseIdentifier: ListsButtonCell.identifier,
                                                               for: indexPath)

        guard let cell = optionDefaultCell else {
            return UICollectionViewCell()
        }

        if infoAboutUserLists.isEmpty {

            if indexPath.section == 0 {
                cell.configure(userImageName: defaultImageForLists[indexPath.item],
                               listName: defaultNamesForLists[indexPath.item].listName)
                return cell
            } else {
                return addButtonCell
            }

        } else {
            let numberOfUserLists = infoAboutUserLists[indexPath.section].items.count

            if indexPath.section != 0 && indexPath.item == numberOfUserLists {
                return addButtonCell
            }

            let listName = infoAboutUserLists[indexPath.section].items[indexPath.item].name
            let numberPlaces = infoAboutUserLists[indexPath.section].items[indexPath.item].listItems.count

            if indexPath.section == 0 {
                cell.configure(backgroundImageName: "listsCellBackground",
                               userImageName: defaultImageForLists[indexPath.item],
                               listName: listName,
                               numberPlaces: "\(numberPlaces)")
            } else {
                cell.configure(backgroundImageName: "listsCellBackground",
                               userImageName: userImageDefault,
                               listName: listName,
                               numberPlaces: "\(numberPlaces)")
            }

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
