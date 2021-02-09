//
//  ListsViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 03.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol ListsViewControllerDelegate: class {
    func listsViewController(_ viewController: ListsViewController,
                             didTapSetupAlert alert: inout CreateNewListAlert!)
    func listsViewController(_ viewController: ListsViewController,
                             didShowAlert alert: CreateNewListAlert!,
                             visualEffectView: UIVisualEffectView,
                             scale: CGFloat,
                             duration: Double)
    func listsViewController(_ viewController: ListsViewController,
                             didHideAlert alert: CreateNewListAlert!,
                             visualEffectView: UIVisualEffectView,
                             scale: CGFloat,
                             duration: Double)
    func listsViewController(_ viewController: ListsViewController,
                             didTapCreateNewListWith parameters: (name: String?,
                                                                  description: String?,
                                                                  flag: Bool),
                             token: String)
}

class ListsViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private var createNewListAlert: CreateNewListAlert!
    private var userLists = [GetUserListsGroup]()
    private let networkManager = NetworkManager.shared
    private let keychainManager = KeychainManager.shared
    private let defaultNameLists = [DefaultNameListsModel(listName: "DefaultNameListsName.MySavedPlaces".localized()),
                                    DefaultNameListsModel(listName: "DefaultNameListsName.MyLikedPlaces".localized())]

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

    weak var delegate: ListsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.refreshControl = refreshControl
        setupScreen()
        setupCollectionCells()
        setupVisualEffectView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateDataOnScreen()
    }
}

// MARK: - AlertDelegate
extension ListsViewController: CreateNewListAlertDelegate {

    func createNewListAlertDidEndInteraction(_ createNewListAlert: CreateNewListAlert) {
        startAnimationForAlert(key: .hide)
    }

    func createNewListAlert(_ createNewListAlert: CreateNewListAlert,
                            createListWith name: String?,
                            description: String?,
                            collaborativeFlag: Bool) {

        delegate?.listsViewController(self,
                                      didTapCreateNewListWith: (name: name,
                                                                description: description,
                                                                flag: collaborativeFlag),
                                      token: getToken())
    }

    func startAnimationForAlert(key animation: AlertAnimationKeys) {
        let scale: CGFloat = 1.3
        let duration = 0.4

        switch animation {
        case .show:
            delegate?.listsViewController(self,
                                          didShowAlert: createNewListAlert,
                                          visualEffectView: visualEffectView,
                                          scale: scale,
                                          duration: duration)
        case .hide:
            delegate?.listsViewController(self,
                                          didHideAlert: createNewListAlert,
                                          visualEffectView: visualEffectView,
                                          scale: scale,
                                          duration: duration)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ListsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if userLists.isEmpty {
            switch KeysForSections.arrayOfKeysForSection[indexPath.section] {
            case .sectionOfStandardCells:
                break
            case .sectionOfUserCells:
                setupAndShowErrorAlert()
            }
        } else {
            let numberOfUserLists = userLists[indexPath.section].items.count

            if indexPath.item == numberOfUserLists {
                delegate?.listsViewController(self,
                                              didTapSetupAlert: &createNewListAlert)
                startAnimationForAlert(key: .show)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ListsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return KeysForSections.arrayOfKeysForSection.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        switch KeysForSections.arrayOfKeysForSection[section] {
        case .sectionOfStandardCells:
            return defaultNameLists.count
        case .sectionOfUserCells:
            return userLists.isEmpty ? 1 : userLists[section].count + 1
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

        if userLists.isEmpty {
            let title = setupHeaderTitle(title: listOfHeaderNames[indexPath.section].title,
                                         type: listOfHeaderNames[indexPath.section].type,
                                         numberOfLists: nil)
            header.configure(title: title)
        } else {
            let title = setupHeaderTitle(title: userLists[indexPath.section].name,
                                         type: userLists[indexPath.section].type,
                                         numberOfLists: userLists[indexPath.section].count)
            header.configure(title: title)
        }

        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellWithButton = dequeueReusableCellWithButton(collectionView, indexPath: indexPath)
        let userCell = dequeueReusableUserCell(collectionView, indexPath: indexPath)

        guard let cell = userCell else {
            return UICollectionViewCell()
        }

        let defaultImageForLists = [DefaultImage.userImageWithBookmark.switchImage,
                                    DefaultImage.userImageWithHeart.switchImage]
        let userImageDefault = DefaultImage.userImageDefault.switchImage

        if userLists.isEmpty {

            switch KeysForSections.arrayOfKeysForSection[indexPath.section] {
            case .sectionOfStandardCells:

                let image = setupImageForCell(prefix: nil,
                                              suffix: nil)

                cell.configure(image: image,
                               userImageName: defaultImageForLists[indexPath.item],
                               listName: defaultNameLists[indexPath.item].listName,
                               numberPlaces: setupNumberPlaces(numberPlaces: userLists.count))
                return cell
            case .sectionOfUserCells:
                return cellWithButton
            }
        } else {
            let numberOfUserLists = userLists[indexPath.section].items.count

            if indexPath.item == numberOfUserLists {
                return cellWithButton
            }

            let userListsItems = userLists[indexPath.section].items[indexPath.item]
            let listName = userListsItems.name
            let numberPlaces = userListsItems.listItems.count
            let number = setupNumberPlaces(numberPlaces: numberPlaces)
            let prefix = userListsItems.photo?.prefix
            let suffix = userListsItems.photo?.suffix
            let userImage = setImageName(indexPath: indexPath,
                                         defaultImageForLists: defaultImageForLists,
                                         userImageDefault: userImageDefault)
            let image = setupImageForCell(prefix: prefix,
                                          suffix: suffix)
            cell.configure(image: image,
                           userImageName: userImage,
                           listName: listName,
                           numberPlaces: number)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ListsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsInRow: CGFloat = 2
        let numberOfHorizontalIndents: CGFloat = 3
        let numberOfVerticalIndents: CGFloat = 2
        let offset: CGFloat = 10

        let collectionViewBounds = collectionView.bounds
        let widthCell = collectionViewBounds.width / numberOfCellsInRow
        let heightCell: CGFloat = widthCell
        let spacing = numberOfHorizontalIndents * offset / numberOfCellsInRow

        return CGSize(width: widthCell - spacing, height: heightCell - offset * numberOfVerticalIndents)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 35)
    }
}

// MARK: - Setup showing and hiding alerts
private extension ListsViewController {

    func setupVisualEffectView() {
        view.addSubview(visualEffectView)
        visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.alpha = 0
    }

    func setupAndShowErrorAlert() {
        let controller = UIAlertController(title: "AlertErrorTitle".localized(),
                                           message: "ListsViewController.AlertToErrorMessage".localized(),
                                           preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancel)
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - Setup screen
private extension ListsViewController {

    func setupImageForCell(prefix: String?, suffix: String?) -> UIImage {
        let url = getPhotoURL(prefix: prefix,
                              suffix: suffix,
                              with: .middle)
        let imageView = UIImageView()

        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "listsCellBackground"),
                              options: [.transition(.fade(1.0))],
                              progressBlock: nil)

        guard let image = imageView.image else { return UIImage()}

        return image
    }

    func setupHeaderTitle(title: String, type: String, numberOfLists: Int?) -> String {
        if type == TypeHeader.yours.rawValue {
            return title
        } else {

            guard let number = numberOfLists else {
                return title
            }

            return title + " (\(number))"
        }
    }

    func setupNumberPlaces(numberPlaces: Int) -> String {
        if numberPlaces == 0 {
            return "UserCreatedCell.NumberPlacesLabel".localized()
        } else {
            return "\(numberPlaces) " + "UserCreatedCell.Places".localized()
        }
    }

    func setImageName(indexPath: IndexPath, defaultImageForLists: [String], userImageDefault: String) -> String {
        switch KeysForSections.arrayOfKeysForSection[indexPath.section] {
        case .sectionOfStandardCells:
            return defaultImageForLists[indexPath.item]
        case  .sectionOfUserCells:
            return userImageDefault
        }
    }

    func dequeueReusableCellWithButton(_ collectionView: UICollectionView,
                                       indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellWithButton.identifier, for: indexPath)
        return cell

    }

    func dequeueReusableUserCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UserCreatedCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCreatedCell.identifier,
                                                            for: indexPath) as? UserCreatedCell
        return cell
    }

    func setupScreen() {
        collectionView.refreshControl = refreshControl
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = .systemBlue
        navBar?.backgroundColor = .systemBlue
        navBar?.barTintColor = .systemBlue
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white,
                                       .font: UIFont.boldSystemFont(ofSize: 22)]
    }

    func updateDataOnScreen() {
        if userLists.isEmpty {
            getUserLists()
        }
    }

    func setupCollectionCells() {
        collectionView.register(UserCreatedCell.nib(),
                                forCellWithReuseIdentifier: UserCreatedCell.identifier)
        collectionView.register(CellWithButton.nib(), forCellWithReuseIdentifier: CellWithButton.identifier)
        collectionView.register(HeaderCollectionView.nib(),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionView.identifier)
    }

    func setupActivityIndicator(isHidden: Bool) {
        activityIndicator.isHidden = !isHidden

        if isHidden {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    @objc func refresh(sender: UIRefreshControl) {
        getUserLists()
        sender.endRefreshing()
        collectionView.reloadData()
    }
}

// MARK: - Work with a keychain
private extension ListsViewController {

    func checkForAuthorization() -> Bool {
        return keychainManager.checkForDataAvailability(for: getTokenKey())
    }

    func getTokenKey() -> String {
        return KeychainKey.accessToken.currentKey
    }

    func getToken() -> String {
        return keychainManager.getValue(for: getTokenKey())
    }

    func getUserLists() {
        let checkToken = checkForAuthorization()

        if checkToken {
            if userLists.isEmpty {
                setupActivityIndicator(isHidden: checkToken)
            }
            networkManager.getUserLists(token: getToken()) { (userLists, isSuccessful) in
                if isSuccessful {
                    guard let userLists = userLists else {
                        self.setupActivityIndicator(isHidden: !checkToken)
                        return
                    }

                    DispatchQueue.main.async {
                        self.userLists = userLists
                        self.setupActivityIndicator(isHidden: !checkToken)
                        self.collectionView.reloadData()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.setupActivityIndicator(isHidden: !checkToken)
                    }
                }

            }
        }
    }
}
