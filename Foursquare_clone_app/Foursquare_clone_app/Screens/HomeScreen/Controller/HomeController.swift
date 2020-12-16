//
//  ViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 14.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!

    private let standardCategories = arrayStandardCategories
    private let numberOfCellsInRow = 3
    private let numberOfRowInCollectionView = 2
    private let offset: CGFloat = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(StandardCategoryCell.nib(),
                                forCellWithReuseIdentifier: StandardCategoryCell.identifier)
    }
    @IBAction func searchButtonPress(_ sender: UIButton) {

    }
}
extension HomeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NetworkManager.shared().searchQuery(categoryName: standardCategories[indexPath.item].imageName) { (data) in
            guard let data = data else {return}

        }
        print("didSelectItemAt")
    }
}
extension HomeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return standardCategories.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageName = standardCategories[indexPath.item].imageName
        let categoryTitle = standardCategories[indexPath.item].title

        let optionCell = collectionView.dequeueReusableCell(withReuseIdentifier: StandardCategoryCell.identifier,
                                                      for: indexPath) as? StandardCategoryCell
        guard let cell = optionCell else {return UICollectionViewCell()}
        cell.configure(imageName: imageName, categoryTitle: categoryTitle)

        return cell
    }
}
extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionViewBounds = collectionView.bounds
        let widthCell = collectionViewBounds.width / CGFloat(numberOfCellsInRow)
        let heightCell = collectionViewBounds.height / CGFloat(numberOfRowInCollectionView)
        let spacing = (CGFloat(numberOfCellsInRow + 1)) * offset / CGFloat(numberOfCellsInRow)

        return CGSize(width: widthCell - spacing, height: heightCell - (offset * 2))
    }
}
