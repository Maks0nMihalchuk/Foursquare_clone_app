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

    private let defaultListsName = defaultLists

    private let numberOfCellsInRow = 2
    private let numberOfHorizontalIndents: CGFloat = 3
    private let numberOfVerticalIndents: CGFloat = 2
    private let offset: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lists"
        collectionView.register(ListsCollectionCell.unib(),
                                forCellWithReuseIdentifier: ListsCollectionCell.identifier)
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
        if section == 1 {
            return defaultListsName.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let optionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ListsCollectionCell.identifier,
                                                            for: indexPath) as? ListsCollectionCell
        guard let cell = optionCell else {
            return UICollectionViewCell()
        }

        cell.configure(listName: defaultListsName[indexPath.item].listName)
        return cell
    }

}
extension ListsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let topBottomPadding = offset * numberOfVerticalIndents

        let collectionViewBounds = collectionView.bounds
        let widthCell = collectionViewBounds.width / CGFloat(numberOfCellsInRow)
        let heightCell = widthCell
        let spacing = (numberOfHorizontalIndents) * offset / CGFloat(numberOfCellsInRow)

        return CGSize(width: widthCell - spacing, height: heightCell - topBottomPadding)
    }

}
