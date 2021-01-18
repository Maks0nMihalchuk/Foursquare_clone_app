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
    @IBOutlet private weak var venueNameLabel: UILabel!

    private let numberOfCells = KeysToCells.arrayOfKeysForCells.count
    private let contentOffsetY: CGFloat = 250
    var detailVenue: DetailVenueModel?
    var dataImageVenue: Data?
    private var indexPathForHoursCell = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBlurEffectView()
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
extension DetailViewController: HoursTableCellDelegate {
    func hoursTableCell(_ hoursTableCell: HoursTableCell, for button: UIButton, isRotationImage: Bool) {
        if isRotationImage {
            button.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        } else {
            button.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.zero)
        }
    }

    func hoursTableCell(_ hoursTableCell: HoursTableCell,
                        displayDetailedInfo byPressedButton: Bool,
                        heightView: NSLayoutConstraint,
                        stockHeightView: CGFloat,
                        detailStackView: UIStackView) {
        let duration = 0.25
        let heightMuliplier = 2.2 * heightView.constant

        UIView.animate(withDuration: duration) {
            if !byPressedButton {
                heightView.constant = heightMuliplier
            } else {
                heightView.constant = stockHeightView
            }
            detailStackView.isHidden = !detailStackView.isHidden
            self.tableView.reloadRows(at: [IndexPath(row: self.indexPathForHoursCell, section: 0)], with: .automatic)

            hoursTableCell.layoutIfNeeded()
        }
    }
}
extension DetailViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.y > contentOffsetY {
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
        return numberOfCells
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let detailVenue = detailVenue else {
            return UITableViewCell()
        }

        switch KeysToCells.arrayOfKeysForCells[indexPath.row] {
        case .imageCell:
            let optionImageCell = tableView.dequeueReusableCell(withIdentifier: ImageTableCell.identifier,
                                                                for: indexPath) as? ImageTableCell
            guard let cell = optionImageCell else {
                return UITableViewCell()
            }

            cell.configure(imageData: dataImageVenue, nameVenue: detailVenue.name,
                           shortDescription: detailVenue.tierPrice)
            return cell
        case .shortInfoCell:
            let optionCell = tableView.dequeueReusableCell(withIdentifier: ShortInfoTableCell.identifier,
                                                           for: indexPath) as? ShortInfoTableCell
            guard let cell = optionCell else {
                return UITableViewCell()
            }
            cell.configure(adressVenue: detailVenue.location,
                            hoursVenue: detailVenue.hoursStatus,
                            categoriesVenue: detailVenue.categories,
                            rating: detailVenue.rating, ratingColor: getRatingColor(with: detailVenue.ratingColor))
            return cell
        case .hoursCell:
            indexPathForHoursCell = indexPath.row
            let optionHoursCell = tableView.dequeueReusableCell(withIdentifier: HoursTableCell.identifier,
                                                                for: indexPath) as? HoursTableCell

            guard let hoursCell = optionHoursCell else {
                return UITableViewCell()
            }
            hoursCell.delegate = self
            hoursCell.configure(hoursStatus: detailVenue.hoursStatus,
                                days: detailVenue.timeframesDays,
                                detailHours: detailVenue.timeframesRenderedTime)

            return hoursCell
        case .contactsCell:
            let optionContactCell = tableView.dequeueReusableCell(withIdentifier: ContactTableCell.identifier,
                                                                  for: indexPath) as? ContactTableCell

            guard let contactCell = optionContactCell else {
                return UITableViewCell()
            }

            contactCell.configure(numberText: detailVenue.phone, webSiteURL: detailVenue.webSite)
            return contactCell
        }
    }
}
private extension DetailViewController {

    func getRatingColor (with colorHEXString: String ) -> UIColor {
        return UIColor.init(hexString: colorHEXString)
    }

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
        tableView.register(ShortInfoTableCell.nib(), forCellReuseIdentifier: ShortInfoTableCell.identifier)
        tableView.register(HoursTableCell.nib(), forCellReuseIdentifier: HoursTableCell.identifier)
        tableView.register(ContactTableCell.nib(), forCellReuseIdentifier: ContactTableCell.identifier)
    }

    func setupBlurEffectView () {
        blurEffectView.effect = UIBlurEffect(style: .systemMaterialDark)
        blurEffectView.alpha = 0
    }
}
