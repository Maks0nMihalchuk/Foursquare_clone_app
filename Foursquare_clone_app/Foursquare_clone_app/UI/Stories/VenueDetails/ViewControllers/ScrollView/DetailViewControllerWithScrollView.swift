//
//  ViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 21.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol DetailViewControllerWithScrollViewDelegate: class {
    func detailViewControllerWithScrollView(_ viewController: DetailViewControllerWithScrollView,
                                            didTapFullScreenImage button: UIButton,
                                            with image: UIImage, model: DetailViewModel)
    func detailViewControllerWithScrollView(_ viewController: DetailViewControllerWithScrollView,
                                            didTapBack button: UIButton)
}

class DetailViewControllerWithScrollView: UIViewController {

    @IBOutlet private weak var imageContainerViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var venueNameLabel: UILabel!

    @IBOutlet private weak var staticAddressLabel: UILabel!
    @IBOutlet private weak var staticHoursStatusLabel: UILabel!
    @IBOutlet private weak var staticCategoryLabel: UILabel!

    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var addressVenueLabel: UILabel!
    @IBOutlet private weak var hoursStatusVenueLabel: UILabel!
    @IBOutlet private weak var categoriesVenueLabel: UILabel!

    @IBOutlet private weak var staticHoursLabel: UILabel!
    @IBOutlet private weak var hoursVenueLabel: UILabel!
    @IBOutlet private weak var detailDaysVenueLabel: UILabel!
    @IBOutlet private weak var detailHoursVenueLabel: UILabel!
    @IBOutlet private weak var detailHoursInfoButton: UIButton!
    @IBOutlet private weak var detailInfoStackView: UIStackView!

    @IBOutlet private weak var staticPhoneLabel: UILabel!
    @IBOutlet private weak var staticWebsiteLabel: UILabel!
    @IBOutlet private weak var phoneVenueLabel: UILabel!
    @IBOutlet private weak var websiteVenueLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var fullScreenButtonHeight: NSLayoutConstraint!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    var networking: NetworkManager?
    var venueID = String()
    var viewModel: DetailViewModel? {
        didSet {
            guard let requireViewModel = viewModel else { return }

            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }

                self.reloadUI(with: requireViewModel)
            }
        }
    }

    weak var delegate: DetailViewControllerWithScrollViewDelegate?

    private let tapGestureRecognizer = UITapGestureRecognizer()
    private let gradient = CAGradientLayer()
    private let duration = 0.25

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        navigationController?.isNavigationBarHidden = true

        guard let requiredViewModel = viewModel else { return }

        reloadUI(with: requiredViewModel)
        checkForDataAvailability(with: requiredViewModel)
    }

    @IBAction func screenCloseButtonPressed(_ sender: UIButton) {
        delegate?.detailViewControllerWithScrollView(self, didTapBack: sender)
    }

    @IBAction func stateChangeButtonPressed(_ sender: UIButton) {
        let transform = CGAffineTransform(rotationAngle: .zero)
        UIView.animate(withDuration: duration) {
            sender.imageView?.transform = self.checkState() == HoursTableCallState.decomposed
                ? transform.rotated(by: .pi)
                : transform.rotated(by: .zero)
            self.detailInfoStackView.isHidden = !self.detailInfoStackView.isHidden
        }
    }

    @IBAction func fullScreenDisplayButtonPressed(_ sender: UIButton) {
        guard
            let image = imageView.image,
            let model = viewModel
        else { return }

        delegate?.detailViewControllerWithScrollView(self, didTapFullScreenImage: sender, with: image, model: model)
    }
}

// MARK: - load data
private extension DetailViewControllerWithScrollView {

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
                                                self.viewModel = DetailViewModel(dataModel: detailVenue)
                                                self.setupActivityIndicator(isHidden: false)
                                            }
                                        } else {
                                            DispatchQueue.main.async {
                                                self.setupActivityIndicator(isHidden: false)
                                                self.showAlertError()
                                            }
                                        }
        })
    }
}

// MARK: - SetupUI
private extension DetailViewControllerWithScrollView {

    func setupScrollView() {
        let window = UIApplication.shared.windows[0]
        scrollView.contentInset.top = imageContainerViewHeight.constant - window.safeAreaInsets.top
    }

    func setupHeightfullScreenButton() {
        let window = UIApplication.shared.windows[0]
        fullScreenButtonHeight.constant = imageContainerViewHeight.constant - window.safeAreaInsets.top
    }

    func checkForDataAvailability(with viewModel: DetailViewModel) {
        let defaultTest = "Add Hours".localized()

        if viewModel.hoursStatus != defaultTest {
            detailHoursInfoButton.isHidden = false
        } else {
            detailHoursInfoButton.isHidden = true
        }
    }

    func checkState() -> HoursTableCallState {
        return detailInfoStackView.isHidden ? .decomposed : .folded
    }

    func setupUI() {
        imageView.image = UIImage(named: "img_placeholder")
        gradientSetup()
        setupScrollView()
        setupHeightfullScreenButton()
        venueNameLabel.text = "LabelTextPlaceholder".localized()
        staticAddressLabel.text = "AdressLabelText".localized()
        staticHoursStatusLabel.text = "HoursLabelText".localized()
        staticCategoryLabel.text = "CategoriesLabelText".localized()
        staticHoursLabel.text = "HoursLabelText".localized()
        staticPhoneLabel.text = "PhoneLabelText".localized()
        staticWebsiteLabel.text = "WebSiteLabelText".localized()
        addressVenueLabel.text = "LabelTextPlaceholder".localized()
        ratingLabel.text = "-"
        hoursStatusVenueLabel.text = "LabelTextPlaceholder".localized()
        categoriesVenueLabel.text = "LabelTextPlaceholder".localized()
        hoursVenueLabel.text = "LabelTextPlaceholder".localized()
        detailHoursVenueLabel.text = "LabelTextPlaceholder".localized()
        detailDaysVenueLabel.text = "LabelTextPlaceholder".localized()
        phoneVenueLabel.text = "LabelTextPlaceholder".localized()
        websiteVenueLabel.text = "LabelTextPlaceholder".localized()
    }

    func reloadUI(with viewModel: DetailViewModel) {
        configureBestPhotoContainerView(with: viewModel)
        configureShortInfo(with: viewModel)
        configureHoursContainer(with: viewModel)
        configureContactsContainer(with: viewModel)
        setupScrollView()
        setupHeightfullScreenButton()
    }
}

// MARK: - UI configuration
private extension DetailViewControllerWithScrollView {

    func gradientSetup() {
        gradient.frame = imageView.bounds
        gradient.colors = [UIColor.black.withAlphaComponent(1.0).cgColor,
                           UIColor.black.withAlphaComponent(0.0).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.locations = [0, 0.75, 1]
        imageView.layer.addSublayer(gradient)
    }

    func configureBestPhotoContainerView(with viewModel: DetailViewModel) {
        imageView.kf.setImage(with: viewModel.imageURL,
                              placeholder: UIImage(named: "img_placeholder"),
                              options: [.transition(.fade(1.0))],
                              progressBlock: nil)
        gradientSetup()
        venueNameLabel.text = viewModel.nameVenueAndPrice
    }

    func configureShortInfo(with viewModel: DetailViewModel) {
        addressVenueLabel.text = viewModel.location
        ratingLabel.text = viewModel.rating
        ratingLabel.backgroundColor = viewModel.ratingColor
        hoursStatusVenueLabel.text = viewModel.hoursStatus
        categoriesVenueLabel.text = viewModel.categories
    }

    func configureHoursContainer(with viewModel: DetailViewModel) {
        hoursVenueLabel.text = viewModel.hoursStatus
        detailDaysVenueLabel.text = viewModel.detailDays
        detailHoursVenueLabel.text = viewModel.detailHours
    }

    func configureContactsContainer(with viewModel: DetailViewModel) {
        phoneVenueLabel.text = viewModel.phone
        websiteVenueLabel.text = viewModel.website
    }
}

// MARK: - setup error alert
private extension DetailViewControllerWithScrollView {

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
