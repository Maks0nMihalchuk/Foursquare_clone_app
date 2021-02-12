//
//  SearchController.swift
//  Foursquare_clone_app
//
//  Created by maks on 16.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: class {
    func searchViewController(_ viewController: SearchViewController,
                              didTapOnRowAt indexPath: IndexPath, venueID: String)
    func searchViewController(_ viewController: SearchViewController,
                              didTapBack button: UIButton)
}

class SearchViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    weak var delegate: SearchViewControllerDelegate?

    var venues = [Venue]()
    var launchSearchBar = Bool()
    var searchBarText = String()
    private var pointCoordinates: Geopoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchTableCell.nib(), forCellReuseIdentifier: SearchTableCell.identifier)
        setupSearchBar(searchBar: searchBar, text: searchBarText, isActive: launchSearchBar)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GeopositionManager.shared.subscribeForGeopositionChanges(observer: self)
        pointCoordinates = GeopositionManager.shared.getCurrentPosition()
    }

    override func viewDidDisappear(_ animated: Bool) {
        GeopositionManager.shared.unsubscribeFromGeopositionChanges(observer: self)
    }

    @IBAction func goToBack(_ sender: UIButton) {
        delegate?.searchViewController(self, didTapBack: sender)
    }
}

// MARK: - GeopositionObserverProtocol
extension SearchViewController: GeopositionObserverProtocol {
    func geopositionManager(_ manager: GeopositionManagerPriotocol, didUpdateLocation location: Geopoint) {
        pointCoordinates = location
    }

    func geopositionManager(_ manager: GeopositionManagerPriotocol,
                            didChangeStatus status: GeopositionManagerStatus) { }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard
            let text = searchBar.text,
            let lat = pointCoordinates?.latitude,
            let long = pointCoordinates?.longitude
        else {
            searchBar.resignFirstResponder()
            return
        }

        venues.removeAll()
        tableView.reloadData()

        NetworkManager.shared.getVenues(categoryName: text,
                                        coordinates: (lat: lat,
                                                      long: long)) { (venuesData, isSuccessful)  in

            if isSuccessful {

                guard let venuesData = venuesData else {
                    return
                }

                DispatchQueue.main.async {

                    self.venues = venuesData
                    self.tableView.reloadData()
                }
            } else {
                return
            }
        }
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let venueID = venues[indexPath.row].id
        delegate?.searchViewController(self,
                                       didTapOnRowAt: indexPath,
                                       venueID: venueID)
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let optionCell = tableView.dequeueReusableCell(withIdentifier: SearchTableCell.identifier,
                                                       for: indexPath) as? SearchTableCell

        guard let cell = optionCell else {
            return UITableViewCell()
        }

        let venueName = "\(indexPath.row + 1). \(venues[indexPath.row].name)"
        let address = venues[indexPath.row].location.formattedAddress
        let category = venues[indexPath.row].categories.first?.name
        let content = SearchCellModel(venueName: venueName,
                                      adress: address,
                                      category: category)
        cell.configure(with: content)
        return cell
    }
}

// MARK: - setup searchBar
private extension SearchViewController {

    func setupSearchBar(searchBar: UISearchBar, text: String, isActive: Bool) {
        searchBar.delegate = self
        searchBar.searchTextField.text = text
        searchBar.searchTextField.backgroundColor = .white
        searchBar.clipsToBounds = true

        if isActive {
            searchBar.becomeFirstResponder()
        } else {
            searchBar.resignFirstResponder()
        }
    }
}
