//
//  SearchController.swift
//  Foursquare_clone_app
//
//  Created by maks on 16.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    var venues = [Venue]()
    var launchSearchBar = Bool()
    var searchBarText = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SearchTableCell.nib(), forCellReuseIdentifier: SearchTableCell.identifier)
        setupSearchBar(searchBar: searchBar, text: searchBarText, isActive: launchSearchBar)
    }
    private func setupSearchBar (searchBar: UISearchBar, text: String, isActive: Bool) {
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
    @IBAction func goToBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
extension SearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {return}
        if text == "" {
            searchBar.resignFirstResponder()
            venues.removeAll()
            tableView.reloadData()
        } else {
            NetworkManager.shared.getVenues(categoryName: text) { (venuesData) in
                guard let venuesData = venuesData else {return}
                DispatchQueue.main.async {

                    self.venues = venuesData.response.venues
                    self.tableView.reloadData()
                }
            }
            searchBar.resignFirstResponder()
        }
    }
}
extension SearchController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        NetworkManager.shared.getDetailInfoVenue(venueId: venues[indexPath.row].id) { (detailVenueInfo) in
            guard let detailVenueInfo = detailVenueInfo else {return}

        }
    }
}
extension SearchController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let optionCell = tableView.dequeueReusableCell(withIdentifier: SearchTableCell.identifier,
                                                       for: indexPath) as? SearchTableCell
        guard let cell = optionCell else {return UITableViewCell()}
        let venueName = "\(indexPath.row + 1). \(venues[indexPath.row].name)"
        let address = venues[indexPath.row].location.formattedAddress
        let category = venues[indexPath.row].categories.first?.name
        cell.configure(venueName: venueName, address: address, category: category)
        return cell
    }
}
