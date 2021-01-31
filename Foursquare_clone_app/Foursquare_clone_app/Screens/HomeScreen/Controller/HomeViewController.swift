//
//  ViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 14.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!

    private let standardCategories = defaultCategoriesList
    private let numberOfCellsInRow = 3
    private let numberOfRowInCollectionView = 2
    private let numberOfHorizontalIndents: CGFloat = 2
    private let indentWidth: CGFloat = 2
    private let stringURL = "https://www.afisha.uz/ui/materials/2020/06/0932127_b.jpeg"
    private let router = VenueSearchRouting(assembly: VenueSearchAssembly())

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CategoryCollectionCell.nib(),
                                forCellWithReuseIdentifier: CategoryCollectionCell.identifier)
        setupImageView()
    }

    @IBAction func searchButtonPress(_ sender: UIButton) {
        showSearchViewController(model: [Venue](),
                                 isActiveSearchBar: true, text: "")
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let standardCategory = standardCategories[indexPath.item].imageName
        NetworkManager.shared.getVenues(categoryName: standardCategory) { (venuesData, isSuccessful) in
            if isSuccessful {

                guard let venuesData = venuesData else {
                    return
                }

                DispatchQueue.main.async {
                    self.showSearchViewController(model: venuesData,
                                                  isActiveSearchBar: false,
                                                  text: self.standardCategories[indexPath.item].title)
                }
            } else {
                return
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return standardCategories.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let optionCell =
            collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.identifier,
                                               for: indexPath) as? CategoryCollectionCell
        guard let cell = optionCell else {
            return UICollectionViewCell()
        }
        let imageName = standardCategories[indexPath.item].imageName
        let categoryTitle = standardCategories[indexPath.item].title

        cell.configure(imageName: imageName, categoryTitle: categoryTitle)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewBounds = collectionView.bounds

        let widthCell = (collectionViewBounds.width
            - indentWidth
            * numberOfHorizontalIndents)
            / CGFloat(numberOfCellsInRow)
        let heightCell = collectionViewBounds.height / CGFloat(numberOfRowInCollectionView)

        return CGSize(width: widthCell, height: heightCell)
    }
}

// MARK: - creating and showing a SearchController
private extension HomeViewController {

    func showSearchViewController(model: [Venue], isActiveSearchBar: Bool, text: String) {
        router.showVenueSearchStory(from: self,
                                    model: model,
                                    isActiveSearchBar: isActiveSearchBar,
                                    searchBarText: text) { (_) in
                                        self.router.hideVenueSearchStory(animated: true)
        }
    }
}

// MARK: - setup imageView
private extension HomeViewController {

    func setupImageView() {
        let url = URL(string: stringURL)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "img_placeholder"),
                              options: [.transition(.fade(1.0))],
                              progressBlock: nil)
    }
}
