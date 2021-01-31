//
//  DetailViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 15.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: class {
    func detailViewController(_ viewController: DetailViewController,
                              didTapToShowFullScreenImage imageView: UIImageView, name: String)
    func detailViewController(_ viewController: DetailViewController, didTapBack button: UIButton)
}

class DetailViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var customViewNavBar: UIView!
    @IBOutlet private weak var blurEffectView: UIVisualEffectView!
    @IBOutlet private weak var venueNameLabel: UILabel!

    private let numberOfCells = KeysForCells.arrayOfKeysForCells.count
    private let contentOffsetY: CGFloat = 250
    private let numberOfCellsWhenNoData = 1
    private var defaultHoursCellStatus = true

    var viewModel: DetailViewModel? {
        didSet {
            guard viewModel != nil else { return }

            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }

                self.tableView.reloadData()
            }
        }
    }

    weak var delegate: DetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupTableView()
        setupBlurEffectView()
        tableView.reloadData()
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        delegate?.detailViewController(self, didTapBack: sender)
    }

    @IBAction func resetDataButtonPressed(_ sender: UIButton) {
        viewModel = nil
        tableView.reloadData()
    }

}

// MARK: - ImageTableCellDelegate
extension DetailViewController: ImageTableViewCellDelegate {
    func imageTableCell(_ tableViewCell: ImageTableViewCell,
                        didTapToShowFullScreenImage imageView: UIImageView,
                        name: String) {
        delegate?.detailViewController(self, didTapToShowFullScreenImage: imageView, name: name)
    }
}

// MARK: - HoursTableCellDelegate
extension DetailViewController: HoursTableCellDelegate {

    func hoursTableViewCell(_ cell: HoursTableCell, didChangeStateTo state: HoursTableCallState.Type) {
        let indexPath = self.tableView.indexPath(for: cell)

        guard let index = indexPath else { return }

        self.tableView.reloadRows(at: [IndexPath(row: index.row,
                                                 section: index.section)],
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
        return viewModel != nil ? numberOfCells : numberOfCellsWhenNoData
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let requiredViewModel = viewModel else {
            return getNoDataTableVIewCell(tableView, indexPath)
        }

        switch KeysForCells.arrayOfKeysForCells[indexPath.row] {
        case .imageCell:
            let imageCell = getImageTableCell(tableView, indexPath, with: requiredViewModel)
            return imageCell
        case .shortInfoCell:
            let shortInfoCell = getShortInfoTableCell(tableView, indexPath, with: requiredViewModel)
            return shortInfoCell
        case .hoursCell:
            let hoursCell = getHoursTableCell(tableView, indexPath, with: requiredViewModel)
            hoursCell.delegate = self
            return hoursCell
        case .contactsCell:
            let contactCell = getContactTableCell(tableView, indexPath, with: requiredViewModel)
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

    func getNoDataTableVIewCell(_ tableView: UITableView,
                                _ indexPath: IndexPath) -> UITableViewCell {
        let noDataCell = tableView
            .dequeueReusableCell(withIdentifier: NoDataTableViewCell.getIdentifier(), for: indexPath)

        return noDataCell
    }

    func getImageTableCell(_ tableView: UITableView,
                           _ indexPath: IndexPath,
                           with viewModel: DetailViewModel) -> ImageTableViewCell {
        let optionImageCell = tableView
            .dequeueReusableCell(withIdentifier: ImageTableViewCell.getIdentifier(),
                                                            for: indexPath) as? ImageTableViewCell

        guard let cell = optionImageCell else {
            return ImageTableViewCell()
        }

        cell.delegate = self
        let image = getImage(url: viewModel.imageURL)
        let content = ImageCellViewModel(image: image, nameVenue: viewModel.nameVenueAndPrice)
        cell.configure(with: content, venueName: viewModel.venueName)
        return cell
    }

    func getShortInfoTableCell(_ tableView: UITableView,
                               _ indexPath: IndexPath,
                               with viewModel: DetailViewModel) -> ShortInfoTableCell {
        let optionShortInfoCell = tableView.dequeueReusableCell(withIdentifier: ShortInfoTableCell.getIdentifier(),
                                                                for: indexPath) as? ShortInfoTableCell

        guard let cell = optionShortInfoCell else {
            return ShortInfoTableCell()
        }

        let content = ShortInfoCellModel(adressVenue: viewModel.location,
                                         hoursVenue: viewModel.hoursStatus,
                                         categoriesVenue: viewModel.categories,
                                         rating: viewModel.rating,
                                         ratingColor: viewModel.ratingColor)
        cell.configure(with: content)
        return cell
    }

    func getHoursTableCell(_ tableView: UITableView,
                           _ indexPath: IndexPath,
                           with viewModel: DetailViewModel) -> HoursTableCell {
        let optionHoursCell = tableView.dequeueReusableCell(withIdentifier: HoursTableCell.getIdentifier(),
                                                            for: indexPath) as? HoursTableCell

        guard let cell = optionHoursCell else {
            return HoursTableCell()
        }

        let detailContent = DetailHours(days: viewModel.detailDays,
                                        detailHours: viewModel.detailHours)
        let content = HoursCellModel(hoursStatus: viewModel.hoursStatus,
                                     detailHours: detailContent,
                                     state: defaultHoursCellStatus)
        cell.configure(with: content)
        defaultHoursCellStatus = !defaultHoursCellStatus
        return cell
    }

    func getContactTableCell(_ tableView: UITableView,
                             _ indexPath: IndexPath,
                             with viewModel: DetailViewModel) -> ContactTableCell {
        let optionContactCell = tableView.dequeueReusableCell(withIdentifier: ContactTableCell.getIdentifier(),
                                                              for: indexPath) as? ContactTableCell

        guard let cell = optionContactCell else {
            return ContactTableCell()
        }

        let content = ContactCellModel(phone: viewModel.phone,
                                       webSiteURL: viewModel.website)
        cell.configure(with: content)

        return cell
    }
}

// MARK: - setup tableView
private extension DetailViewController {

    func setupTableView() {
        tableView.contentInset.bottom = 16
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(NoDataTableViewCell.getNib(),
                           forCellReuseIdentifier: NoDataTableViewCell.getIdentifier())
        tableView.register(ImageTableViewCell.getNib(),
                           forCellReuseIdentifier: ImageTableViewCell.getIdentifier())
        tableView.register(ShortInfoTableCell.getNib(),
                           forCellReuseIdentifier: ShortInfoTableCell.getIdentifier())
        tableView.register(HoursTableCell.getNib(),
                           forCellReuseIdentifier: HoursTableCell.getIdentifier())
        tableView.register(ContactTableCell.getNib(),
                           forCellReuseIdentifier: ContactTableCell.getIdentifier())
    }
}

// MARK: - Get Image for imageCell
private extension DetailViewController {

    func getImage(url: URL?) -> UIImage? {
        let imageView = UIImageView()
        imageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "img_placeholder"),
                              options: [.transition(.fade(1.0))],
                              progressBlock: nil)
        return imageView.image
    }
}
