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

    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar(searchController: searchController)
    }
    private func setupSearchBar (searchController: UISearchController) {
        searchController.searchBar.text = "12311321"
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        
    }
    @objc private func goToBack () {

    }

}
extension SearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
extension SearchController: UITableViewDelegate {

}
extension SearchController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
