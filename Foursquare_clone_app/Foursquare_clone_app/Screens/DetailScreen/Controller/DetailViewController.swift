//
//  DetailViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 15.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var customViewNavBar: UIView!
    @IBOutlet private weak var blurEffectView: UIVisualEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBlurEffectView()
    }

}
extension DetailViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.y > 60 {
            showCustomNavBar()
        } else {
            hideCustopNavBar()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            let optionImageCell = tableView.dequeueReusableCell(withIdentifier: ImageTableCell.identifier,
                                                                for: indexPath) as? ImageTableCell
            guard let cell = optionImageCell else {
                return UITableViewCell()
            }

            cell.configure(imageData: "image", nameVenue: "Чай Кофе", shortDescription: "Кефейня в Кривом Роге * $$$$")
            return cell
        default:
            let optionCell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier,
                                                           for: indexPath) as? TableViewCell
            guard let cell = optionCell else {
                return UITableViewCell()
            }

            cell.configure(itemName: "Item: \(indexPath.row)", information: "Information: \(indexPath.row)")

            return cell
        }

    }
}
private extension DetailViewController {

    func showCustomNavBar () {
        let duration = 0.6

        UIView.animate(withDuration: duration) {
            self.blurEffectView.alpha = 1
            self.customViewNavBar.backgroundColor = .white
        }
    }

    func hideCustopNavBar () {
        let duration = 0.6

        UIView.animate(withDuration: duration) {
            self.blurEffectView.alpha = 0
            self.customViewNavBar.backgroundColor = .clear
        }
    }

    func setupTableView () {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(ImageTableCell.nib(), forCellReuseIdentifier: ImageTableCell.identifier)
        tableView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
    }

    func setupBlurEffectView () {
        blurEffectView.effect = UIBlurEffect(style: .systemMaterialDark)
        blurEffectView.alpha = 0
    }
}
