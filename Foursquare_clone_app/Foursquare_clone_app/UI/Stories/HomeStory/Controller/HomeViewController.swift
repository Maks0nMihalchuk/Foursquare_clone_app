//
//  ViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 14.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import UIKit
import Kingfisher

protocol HomeViewControllerDelegate: class {
    func homeViewController(_ viewController: HomeViewController,
                            didStartedSearchingWith model: [Venue],
                            setupSearchBar: (activateSearchBar: Bool,
                                             searchBarText: String),
                            router: VenueSearchRouting,
                            animated: Bool)
}

class HomeViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var coordinatesLabel: UILabel!

    private let standardCategories = defaultCategoriesList
    private let numberOfCellsInRow = 3
    private let numberOfRowInCollectionView = 2
    private let numberOfHorizontalIndents: CGFloat = 2
    private let indentWidth: CGFloat = 2
    private let stringURL = "https://www.afisha.uz/ui/materials/2020/06/0932127_b.jpeg"
    private let router = VenueSearchRouting(assembly: VenueSearchAssembly())
    private var pointCoordinates: Geopoint?

    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CategoryCollectionCell.nib(),
                                forCellWithReuseIdentifier: CategoryCollectionCell.identifier)
        setupImageView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GeopositionManager.shared.subscribeForGeopositionChanges(observer: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        GeopositionManager.shared.unsubscribeFromGeopositionChanges(observer: self)
    }

    @IBAction func searchButtonPress(_ sender: UIButton) {
        delegate?.homeViewController(self,
                                     didStartedSearchingWith: [Venue](),
                                     setupSearchBar: (activateSearchBar: true,
                                                      searchBarText: ""),
                                     router: router,
                                     animated: true)
    }
}

// MARK: - GeopositionObserverProtocol
extension HomeViewController: GeopositionObserverProtocol {
    func geopositionManager(_ manager: GeopositionManagerPriotocol, didUpdateLocation location: Geopoint) {
        pointCoordinates = location
        coordinatesLabel.text = "lat: \(location.latitude) | long: \(location.longitude)"
    }

    func geopositionManager(_ manager: GeopositionManagerPriotocol, didChangeStatus status: GeopositionManagerStatus) {
        switch status {
        case .started:
            return
        case .stopped:
            setupErrorAlert()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let lat = pointCoordinates?.latitude,
            let long = pointCoordinates?.longitude
            else { return }

        let standardCategory = standardCategories[indexPath.item].imageName
        let searchBarText = standardCategories[indexPath.item].title

        NetworkManager.shared.getVenues(categoryName: standardCategory,
                                        coordinates: (lat: lat, long: long)) { (venuesData, isSuccessful) in
            if isSuccessful {

                guard let venuesData = venuesData else { return }

                DispatchQueue.main.async {
                    self.delegate?.homeViewController(self,
                                                      didStartedSearchingWith: venuesData,
                                                      setupSearchBar: (activateSearchBar: false,
                                                                       searchBarText: searchBarText),
                                                      router: self.router,
                                                      animated: true)
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
