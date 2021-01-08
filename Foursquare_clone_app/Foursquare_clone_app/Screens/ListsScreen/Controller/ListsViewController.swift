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

    private let defaultNamesForLists = defaultNameLists
    private let defaultHeaderLists = listOfHeaderNames

    private let numberOfCellsInRow = 2
    private let numberOfHorizontalIndents: CGFloat = 3
    private let numberOfVerticalIndents: CGFloat = 2
    private let offset: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lists"

        setupCollectionCells()
    }

    private func setupCollectionCells () {
        collectionView.register(UserCreatedCells.nib(),
                                forCellWithReuseIdentifier: UserCreatedCells.identifier)
        collectionView.register(ListsButtonCell.nib(), forCellWithReuseIdentifier: ListsButtonCell.identifier)
        collectionView.register(HeaderCollectionView.nib(),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionView.identifier)
    }

    private func checkForAuthorization () {

    }

}
extension ListsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

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
            return 1
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

        if indexPath.section == 0 {
            header.configure(title: defaultHeaderLists[indexPath.section].title, numberOfLists: nil)
        } else {
            header.configure(title: defaultHeaderLists[indexPath.section].title, numberOfLists: 5)
        }

        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.section == 0 {
            let optionCell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCreatedCells.identifier,
                                                                for: indexPath) as? UserCreatedCells
            guard let cell = optionCell else {
                return UICollectionViewCell()
            }

            cell.configure(userImageName: defaultImageForLists[indexPath.item],
                           listName: defaultNamesForLists[indexPath.item].listName)
            return cell
        } else {

            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListsButtonCell.identifier,
                                                              for: indexPath)
                return cell
            } else {
                return UICollectionViewCell()
            }
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
