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
    private let numberOfHorizontalIndents: CGFloat = 4
    private let numberOfVerticalIndents: CGFloat = 2
    private let offset: CGFloat = 2
    private let main = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CategoryCollectionCell.nib(),
                                forCellWithReuseIdentifier: CategoryCollectionCell.identifier)
    }
    @IBAction func searchButtonPress(_ sender: UIButton) {
        let searchController = self.main.instantiateViewController(identifier: "SearchController")
        as? SearchController
        guard let search = searchController else {return}
        search.searchBarText = ""
        search.launchSearchBar = true
        search.modalPresentationStyle = .fullScreen
        self.present(search, animated: true, completion: nil)
    }
}
extension HomeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NetworkManager.shared.getVenues(categoryName: standardCategories[indexPath.item].imageName) { (venuesData) in
            guard let venuesData = venuesData else {return}
            DispatchQueue.main.async {
                let searchController = self.main.instantiateViewController(identifier: "SearchController")
                    as? SearchController

                guard let search = searchController else {return}
                search.venues = venuesData.response.venues
                search.searchBarText = self.standardCategories[indexPath.item].title
                search.launchSearchBar = false
                search.modalPresentationStyle = .fullScreen
                self.present(search, animated: true, completion: nil)
            }
        }
    }
}
extension HomeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return standardCategories.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let optionCell =
            collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.identifier,
                                                            for: indexPath) as? CategoryCollectionCell
        guard let cell = optionCell else {return UICollectionViewCell()}
        let imageName = standardCategories[indexPath.item].imageName
        let categoryTitle = standardCategories[indexPath.item].title

        cell.configure(imageName: imageName, categoryTitle: categoryTitle)

        return cell
    }
}
extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let topBottomPadding = offset * numberOfVerticalIndents

        let collectionViewBounds = collectionView.bounds
        let widthCell = collectionViewBounds.width / CGFloat(numberOfCellsInRow)
        let heightCell = collectionViewBounds.height / CGFloat(numberOfRowInCollectionView)
        let spacing = (numberOfHorizontalIndents) * offset / CGFloat(numberOfCellsInRow)

        return CGSize(width: widthCell - spacing, height: heightCell - topBottomPadding)
    }
}
