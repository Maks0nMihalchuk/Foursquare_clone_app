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

    private let numberOfCells = KeysForCells.arrayOfKeysForCells.count
    private let contentOffsetY: CGFloat = 250
    private var hoursCellStatus = true
    var detailVenue: DetailVenueModel?
    var dataImageVenue: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBlurEffectView()
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - HoursTableCellDelegate
extension DetailViewController: HoursTableCellDelegate {
    func changeStateHoursCell(_ hoursTableCell: HoursTableCell) {
        let indexPath = self.tableView.indexPath(for: hoursTableCell)
        self.tableView.reloadRows(at: [IndexPath(row: indexPath!.row,
                                                 section: indexPath!.section)],
                                  with: .fade)
    }
}

// MARK: - UITableViewDelegate
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

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let detailVenue = detailVenue else {
            return UITableViewCell()
        }

        switch KeysForCells.arrayOfKeysForCells[indexPath.row] {
        case .imageCell:
            let imageCell = getImageTableCell(tableView, indexPath, dataModel: detailVenue)
            return imageCell
        case .shortInfoCell:
            let shortInfoCell = getShortInfoTableCell(tableView, indexPath, dataModel: detailVenue)
            return shortInfoCell
        case .hoursCell:
            let hoursCell = getHoursTableCell(tableView, indexPath, dataModel: detailVenue)
            hoursCell.delegate = self
            return hoursCell
        case .contactsCell:
            let contactCell = getContactTableCell(tableView, indexPath, dataModel: detailVenue)
            return contactCell
        }
    }
}

// MARK: - setup, show and hide customNavBar
private extension DetailViewController {
    func setupBlurEffectView() {
        blurEffectView.effect = UIBlurEffect(style: .systemMaterialDark)
        blurEffectView.alpha = 0
    }

    func showCustomNavBar() {
        let duration = 0.6

        UIView.animate(withDuration: duration) {
            self.blurEffectView.alpha = 1
            self.customViewNavBar.backgroundColor = .white
        }
    }

    func hideCustopNavBar() {
        let duration = 0.6

        UIView.animate(withDuration: duration) {
            self.blurEffectView.alpha = 0
            self.customViewNavBar.backgroundColor = .clear
        }
    }
}

// MARK: - setup tableViewCell
private extension DetailViewController {
    func getImageTableCell(_ tableView: UITableView,
                           _ indexPath: IndexPath,
                           dataModel: DetailVenueModel) -> ImageTableCell {
        let optionImageCell = tableView.dequeueReusableCell(withIdentifier: ImageTableCell.getIdentifier(),
                                                            for: indexPath) as? ImageTableCell

        guard let cell = optionImageCell else {
            return ImageTableCell()
        }

        let content = ImageCellModel(imageData: dataImageVenue,
                                     nameVenue: dataModel.name,
                                     shortDescription: dataModel.tierPrice)
        cell.configure(with: content)
        return cell
    }

    func getShortInfoTableCell(_ tableView: UITableView,
                               _ indexPath: IndexPath,
                               dataModel: DetailVenueModel) -> ShortInfoTableCell {
        let optionShortInfoCell = tableView.dequeueReusableCell(withIdentifier: ShortInfoTableCell.getIdentifier(),
                                                                for: indexPath) as? ShortInfoTableCell

        guard let cell = optionShortInfoCell else {
            return ShortInfoTableCell()
        }

        let content = ShortInfoCellModel(adressVenue: dataModel.location,
                                         hoursVenue: dataModel.hoursStatus,
                                         categoriesVenue: dataModel.categories,
                                         rating: dataModel.rating,
                                         ratingColor: getRatingColor(with: dataModel.ratingColor))
        cell.configure(with: content)
        return cell
    }

    func getHoursTableCell(_ tableView: UITableView,
                           _ indexPath: IndexPath,
                           dataModel: DetailVenueModel) -> HoursTableCell {
        let optionHoursCell = tableView.dequeueReusableCell(withIdentifier: HoursTableCell.getIdentifier(),
                                                            for: indexPath) as? HoursTableCell

        guard let cell = optionHoursCell else {
            return HoursTableCell()
        }

        let detailContent = DetailHours(days: dataModel.timeframesDays,
                                        detailHours: dataModel.timeframesRenderedTime)
        let content = HoursCellModel(hoursStatus: dataModel.hoursStatus,
                                     detailHours: detailContent,
                                     state: hoursCellStatus)
        cell.configure(with: content, state: hoursCellStatus)
        hoursCellStatus = !hoursCellStatus
        return cell
    }

    func getContactTableCell(_ tableView: UITableView,
                             _ indexPath: IndexPath,
                             dataModel: DetailVenueModel) -> ContactTableCell {
        let optionContactCell = tableView.dequeueReusableCell(withIdentifier: ContactTableCell.getIdentifier(),
                                                              for: indexPath) as? ContactTableCell

        guard let cell = optionContactCell else {
            return ContactTableCell()
        }

        let content = ContactCellModel(phone: dataModel.phone, webSiteURL: dataModel.webSite)
        cell.configure(with: content)

        return cell
    }

    func getRatingColor(with colorHEXString: String ) -> UIColor {
        return UIColor.init(hexString: colorHEXString)
    }
}

// MARK: - setup tableView
private extension DetailViewController {
    func setupTableView() {
        tableView.contentInset.bottom = 16
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(ImageTableCell.getNib(),
                           forCellReuseIdentifier: ImageTableCell.getIdentifier())
        tableView.register(ShortInfoTableCell.getNib(),
                           forCellReuseIdentifier: ShortInfoTableCell.getIdentifier())
        tableView.register(HoursTableCell.getNib(),
                           forCellReuseIdentifier: HoursTableCell.getIdentifier())
        tableView.register(ContactTableCell.getNib(),
                           forCellReuseIdentifier: ContactTableCell.getIdentifier())
    }
}
