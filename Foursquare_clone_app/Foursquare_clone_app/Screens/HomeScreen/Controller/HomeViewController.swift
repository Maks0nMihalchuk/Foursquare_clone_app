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
    private let numberOfHorizontalIndents: CGFloat = 4
    private let numberOfVerticalIndents: CGFloat = 2
    private let offset: CGFloat = 2
    private let main = UIStoryboard(name: "Main", bundle: nil)
    private let stringURL = "https://www.afisha.uz/ui/materials/2020/06/0932127_b.jpeg"
    private var locationManager: GeolocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CategoryCollectionCell.nib(),
                                forCellWithReuseIdentifier: CategoryCollectionCell.identifier)
        setupImageView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager = GeolocationManager()
        locationManager?.subscribe(subscribeTo: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        locationManager?.stopUpdateLocationData()
        locationManager = nil
    }

    @IBAction func searchButtonPress(_ sender: UIButton) {
        createdSearchController(main: main, isActiveSearchBar: true, searchBarText: "", venues: [Venue]())
    }
}

// MARK: - GeolocationObserverProtocol
extension HomeViewController: GeolocationObserverProtocol {

    func geolocationManager(_ locationManager: GeolocationManager, didUpdateData location: GeoPoint) {
        print("latitude: \(location.latitude)")
        print("longitude: \(location.longitude)")
    }

    func geolocationManager(_ locationManager: GeolocationManager, showLocationAccess status: TrackLocationStatus) {

        switch status {
        case .available:
            return
        case .notAvailable:
            setupErrorAlert()
        }
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

                    self.createdSearchController(main: self.main,
                                                 isActiveSearchBar: false,
                                                 searchBarText: self.standardCategories[indexPath.item].title,
                                                 venues: venuesData)
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

        let topBottomPadding = offset * numberOfVerticalIndents

        let collectionViewBounds = collectionView.bounds
        let widthCell = collectionViewBounds.width / CGFloat(numberOfCellsInRow)
        let heightCell = collectionViewBounds.height / CGFloat(numberOfRowInCollectionView)
        let spacing = (numberOfHorizontalIndents) * offset / CGFloat(numberOfCellsInRow)

        return CGSize(width: widthCell - spacing, height: heightCell - topBottomPadding)
    }
}

// MARK: - creating and showing a SearchController
private extension HomeViewController {

    func createdSearchController(main: UIStoryboard,
                                 isActiveSearchBar: Bool,
                                 searchBarText: String,
                                 venues: [Venue]) {
        let searchController = main.instantiateViewController(identifier: "SearchViewController")
            as? SearchViewController

        guard let search = searchController else {
            return
        }

        search.searchBarText = searchBarText
        search.launchSearchBar = isActiveSearchBar
        search.venues = venues
        search.modalPresentationStyle = .fullScreen
        present(search, animated: true, completion: nil)
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

// MARK: - setup and display the location Error alert
private extension HomeViewController {

    func setupErrorAlert() {
        let title = "LocationErrorAlert.Title".localized()
        let message = "LocationErrorAlert.Message".localized()
        let buttonTitle = "LocationErrorAlert.Action".localized()

        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okeyButton = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertController.addAction(okeyButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
