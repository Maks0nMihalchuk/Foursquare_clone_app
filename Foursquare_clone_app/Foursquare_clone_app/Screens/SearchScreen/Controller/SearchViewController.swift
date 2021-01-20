//
//  SearchController.swift
//  Foursquare_clone_app
//
//  Created by maks on 16.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var venues = [Venue]()
    var launchSearchBar = Bool()
    var searchBarText = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SearchTableCell.nib(), forCellReuseIdentifier: SearchTableCell.identifier)
        setupSearchBar(searchBar: searchBar, text: searchBarText, isActive: launchSearchBar)
    }

    @IBAction func goToBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }

        if text.isEmpty {
            searchBar.resignFirstResponder()
            venues.removeAll()
            tableView.reloadData()
        } else {
            NetworkManager.shared.getVenues(categoryName: text) { (venuesData, isSuccessful)  in

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
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        NetworkManager.shared.getDetailInfoVenue(venueId: venues[indexPath.row].id) { (detailVenueInfo, isSuccessful) in

            if isSuccessful {
                guard let detailVenueInfo = detailVenueInfo else {
                    return
                }

                NetworkManager.shared.getPhoto(prefix: detailVenueInfo.prefix,
                                               suffix: detailVenueInfo.suffix) { (imageData) in
                    DispatchQueue.main.async {
                        self.setupAndPresentDetailController(detailVenue: detailVenueInfo, dataImageVenue: imageData)
                    }
                }
            } else {
                self.showAlertError()
                return
            }

        }
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

// MARK: - setup searchBar, DetailController and AlertError
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

    func setupAndPresentDetailController(detailVenue: DetailVenueModel, dataImageVenue: Data?) {
        let detailController = mainStoryboard
            .instantiateViewController(identifier: "DetailViewController") as? DetailViewController

        guard let detail = detailController else {
            return
        }

        detail.detailVenue = detailVenue
        detail.dataImageVenue = dataImageVenue
        detail.modalPresentationStyle = .fullScreen
        present(detail, animated: true, completion: nil)
    }

    func showAlertError() {
        let alertController = UIAlertController(title: "Error",
                                                message: "when downloading data error occurred", preferredStyle: .alert)
        let action = UIAlertAction(title: "AccountViewController.AlertActionTitle".localized(),
                                   style: .default,
                                   handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
