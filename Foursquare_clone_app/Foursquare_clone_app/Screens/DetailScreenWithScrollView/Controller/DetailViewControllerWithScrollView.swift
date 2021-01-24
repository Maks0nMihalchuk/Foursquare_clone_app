//
//  ViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 21.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

class DetailViewControllerWithScrollView: UIViewController {

    @IBOutlet private weak var imageContainerView: UpNavigationViewAnimation!
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

    var viewModel: ViewModel? {
        didSet {
            guard let requireViewModel = viewModel else { return }

            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }

                self.reloadUI(with: requireViewModel)
            }
        }
    }

    private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private let gradient = CAGradientLayer()
    private let duration = 0.25

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setuptapGesture()
        setupImageContainerView()
        setupUI()

        guard let requiredViewModel = viewModel else { return }

        reloadUI(with: requiredViewModel)
        checkForDataAvailability(with: requiredViewModel)
    }

    @IBAction func screenCloseButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func stateChangeButtonPressed(_ sender: UIButton) {
        let transform = CGAffineTransform(rotationAngle: .zero)
        UIView.animate(withDuration: duration) {
            sender.imageView?.transform = self.checkState() == State.decomposed
                ? transform.rotated(by: .pi)
                : transform.rotated(by: .zero)
            self.detailInfoStackView.isHidden = !self.detailInfoStackView.isHidden
        }

    }
}

// MARK: - UIScrollViewDelegate
extension DetailViewControllerWithScrollView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imageContainerView.scrollViewDidScroll(scrollView)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        imageContainerView.scrollViewWillBeginDragging(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        imageContainerView.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        imageContainerView.scrollViewDidEndDecelerating(scrollView)
    }
}

// MARK: - setup tap gesture
private extension DetailViewControllerWithScrollView {

    func setuptapGesture() {
        tapGestureRecognizer.addTarget(self, action: #selector(handleTapPressGesture(_:)))
    }

    @objc func handleTapPressGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard tapGestureRecognizer === gestureRecognizer else { return }

        let fullPhotoScreenControllre = mainStoryboard
            .instantiateViewController(identifier: "FullScreenImageViewController") as? FullScreenImageViewController

        guard let fullPhotoScreen = fullPhotoScreenControllre else { return }

        guard
            let fullScreenImage = imageView.image,
            let venueName = venueNameLabel.text
        else { return }

        fullPhotoScreen.venueName = venueName
        fullPhotoScreen.venueImage = fullScreenImage

        let navigationController = UINavigationController(rootViewController: fullPhotoScreen)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}


// MARK: - SetupUI
private extension DetailViewControllerWithScrollView {

    func checkForDataAvailability(with viewModel: ViewModel) {
        let defaultTest = "Add Hours".localized()

        if viewModel.hoursStatus != defaultTest {
            detailHoursInfoButton.isHidden = false
        } else {
            detailHoursInfoButton.isHidden = true
        }
    }

    func checkState() -> State {
        return detailInfoStackView.isHidden ? .decomposed : .folded
    }

    func setupUI() {
        imageView.image = UIImage(named: "img_placeholder")
        gradientSetup()
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

    func reloadUI(with viewModel: ViewModel) {
        configureBestPhotoContainerView(with: viewModel)
        configureShortInfo(with: viewModel)
        configureHoursContainer(with: viewModel)
        configureContactsContainer(with: viewModel)
    }

    func setupImageContainerView() {
        imageContainerView.setupFor(Scrollview: scrollView, viewController: self)
        imageContainerView.topbarMinimumSpace = .custom(height: 85)
        imageContainerView.isBlurrBackground = false
        imageContainerView.addGestureRecognizer(tapGestureRecognizer)
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

    func configureBestPhotoContainerView(with viewModel: ViewModel) {
        imageView.image = viewModel.image
        gradientSetup()
        venueNameLabel.text = viewModel.nameVenueAndPrice
    }

    func configureShortInfo(with viewModel: ViewModel) {
        addressVenueLabel.text = viewModel.location
        ratingLabel.text = viewModel.rating
        ratingLabel.backgroundColor = viewModel.ratingColor
        hoursStatusVenueLabel.text = viewModel.hoursStatus
        categoriesVenueLabel.text = viewModel.categories
    }

    func configureHoursContainer(with viewModel: ViewModel) {
        hoursVenueLabel.text = viewModel.hoursStatus
        detailDaysVenueLabel.text = viewModel.detailDays
        detailHoursVenueLabel.text = viewModel.detailHours
    }

    func configureContactsContainer(with viewModel: ViewModel) {
        phoneVenueLabel.text = viewModel.phone
        websiteVenueLabel.text = viewModel.website
    }
}
