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
    func detailViewController(_ viewController: DetailViewController,
                              didShowAlertError error: Bool)
    func detailViewController(_ viewController: DetailViewController,
                              didTapShowMap button: UIButton,
                              with viewModel: ShortInfoViewModel)
}

class DetailViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var customViewNavBar: UIView!
    @IBOutlet private weak var blurEffectView: UIVisualEffectView!
    @IBOutlet private weak var venueNameLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var clearButton: UIButton!

    private let numberOfCells = KeysForCells.arrayOfKeysForCells.count
    private let contentOffsetY: CGFloat = 250
    private let numberOfCellsWhenNoData = 1
    private var loadingIndicator = false
    private var defaultHoursCellStatus = false
    private var bestPhotoViewModel: BestPhotoViewModel?
    private var shortInfoViewModel: ShortInfoViewModel?
    private var hoursViewModel: HoursViewModel?
    private var contactViewModel: ContactViewModel?
    private var dataModel: DetailVenueModel? {
        didSet {
            guard let requireDataModel = dataModel else { return }

            self.bestPhotoViewModel = BestPhotoViewModel(dataModel: requireDataModel)
            self.shortInfoViewModel = ShortInfoViewModel(dataModel: requireDataModel)
            self.hoursViewModel = HoursViewModel(dataModel: requireDataModel)
            self.contactViewModel = ContactViewModel(dataModel: requireDataModel)
            self.tableView.reloadData()
        }
    }

    var networking: NetworkManager?
    var venueID = String()

    weak var delegate: DetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
        setupTableView()
        setupBlurEffectView()
        tableView.reloadData()
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        delegate?.detailViewController(self, didTapBack: sender)
    }

    @IBAction func clearDataButtonPressed(_ sender: UIButton) {
        dataModel = nil
        bestPhotoViewModel = nil
        shortInfoViewModel = nil
        hoursViewModel = nil
        contactViewModel = nil
        tableView.reloadData()
    }
}

// MARK: - ShortInfoTableCell
extension DetailViewController: ShortInfoTableCellDelegate {

    func shortInfoTableCell(_ cell: ShortInfoTableCell,
                            didTapShowMapButton button: UIButton) {
        guard let viewModel = shortInfoViewModel else { return }

        delegate?.detailViewController(self, didTapShowMap: button, with: viewModel)
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

    func hoursTableViewCell(_ cell: HoursTableCell,
                            didTapChangeState button: UIButton,
                            to state: HoursTableCallState.Type) {
        let indexPath = self.tableView.indexPath(for: cell)
        let transform = CGAffineTransform(rotationAngle: .zero)

        guard let index = indexPath else { return }

        button.imageView?.transform = defaultHoursCellStatus
            ? transform.rotated(by: .zero)
            : transform.rotated(by: .pi)
        tableView.reloadRows(at: [IndexPath(row: index.row, section: index.section)],
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
        return dataModel != nil ? numberOfCells : numberOfCellsWhenNoData
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard
            let bestPhotoViewModel = bestPhotoViewModel,
            let shortInfoViewModel = shortInfoViewModel,
            let hoursViewModel = hoursViewModel,
            let contactViewModel = contactViewModel
        else {
            return getNoDataTableVIewCell(tableView, indexPath)
        }

        switch KeysForCells.arrayOfKeysForCells[indexPath.row] {
        case .imageCell:
            let imageCell = getImageTableCell(tableView, indexPath, with: bestPhotoViewModel)
            imageCell.delegate = self
            return imageCell
        case .shortInfoCell:
            let shortInfoCell = getShortInfoTableCell(tableView, indexPath, with: shortInfoViewModel)
            shortInfoCell.delegate = self
            return shortInfoCell
        case .hoursCell:
            let hoursCell = getHoursTableCell(tableView, indexPath, with: hoursViewModel)
            hoursCell.delegate = self
            return hoursCell
        case .contactsCell:
            let contactCell = getContactTableCell(tableView, indexPath, with: contactViewModel)
            return contactCell
        }
    }
}

// MARK: - load data
private extension DetailViewController {

    func setupActivityIndicator(isHidden: Bool) {
        activityIndicator.isHidden = !isHidden

        if isHidden {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func loadData() {
        networking?.getDetailInfoVenue(venueId: venueID,
                                       completion: { (detailVenue, isSuccessful) in
                                        DispatchQueue.main.async {
                                            self.setupActivityIndicator(isHidden: true)
                                        }

                                        if isSuccessful {

                                            guard let detailVenue = detailVenue else {
                                                return
                                            }

                                            DispatchQueue.main.async {
                                                self.dataModel = detailVenue
                                                self.setupActivityIndicator(isHidden: false)
                                                self.tableView.reloadData()
                                            }
                                        } else {
                                            DispatchQueue.main.async {
                                                self.setupActivityIndicator(isHidden: false)
                                                self.delegate?.detailViewController(self, didShowAlertError: true)
                                            }
                                        }
        })
    }
}

// MARK: - setup, show and hide customNavBar
private extension DetailViewController {

    func setupView() {
        let clearButtonTitle = "СlearButton".localized(name: "DetailVCLocalization")
        clearButton.setTitle(clearButtonTitle, for: .normal)
        navigationController?.isNavigationBarHidden = true
    }

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
                           with viewModel: BestPhotoViewModel) -> ImageTableViewCell {
        let optionImageCell = tableView
            .dequeueReusableCell(withIdentifier: ImageTableViewCell.getIdentifier(),
                                                            for: indexPath) as? ImageTableViewCell

        guard let cell = optionImageCell else {
            return ImageTableViewCell()
        }

        let image = getImage(url: viewModel.imageURL)
        cell.configure(with: image, venueName: viewModel.nameVenueAndPrice)
        return cell
    }

    func getShortInfoTableCell(_ tableView: UITableView,
                               _ indexPath: IndexPath,
                               with viewModel: ShortInfoViewModel) -> ShortInfoTableCell {
        let optionShortInfoCell = tableView.dequeueReusableCell(withIdentifier: ShortInfoTableCell.getIdentifier(),
                                                                for: indexPath) as? ShortInfoTableCell

        guard let cell = optionShortInfoCell else {
            return ShortInfoTableCell()
        }

        cell.configure(with: viewModel)
        return cell
    }

    func getHoursTableCell(_ tableView: UITableView,
                           _ indexPath: IndexPath,
                           with viewModel: HoursViewModel) -> HoursTableCell {
        let optionHoursCell = tableView.dequeueReusableCell(withIdentifier: HoursTableCell.getIdentifier(),
                                                            for: indexPath) as? HoursTableCell

        guard let cell = optionHoursCell else {
            return HoursTableCell()
        }

        cell.configure(with: viewModel, state: defaultHoursCellStatus)
        defaultHoursCellStatus = !defaultHoursCellStatus
        return cell
    }

    func getContactTableCell(_ tableView: UITableView,
                             _ indexPath: IndexPath,
                             with viewModel: ContactViewModel) -> ContactTableCell {
        let optionContactCell = tableView.dequeueReusableCell(withIdentifier: ContactTableCell.getIdentifier(),
                                                              for: indexPath) as? ContactTableCell

        guard let cell = optionContactCell else {
            return ContactTableCell()
        }

        cell.configure(with: viewModel)
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
                              progressBlock: nil) { (_) in
                                if !self.loadingIndicator {
                                    self.tableView.reloadData()
                                    self.loadingIndicator = true
                                }
        }
        return imageView.image
    }
}
