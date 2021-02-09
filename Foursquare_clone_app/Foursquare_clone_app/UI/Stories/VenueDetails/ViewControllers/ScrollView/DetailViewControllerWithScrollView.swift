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
                                            with image: UIImage, model: ViewModel)
    func detailViewControllerWithScrollView(_ viewController: DetailViewControllerWithScrollView,
                                            didTapBack button: UIButton)
}

class DetailViewControllerWithScrollView: UIViewController {

    @IBOutlet private weak var imageContainerViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var venueNameLabel: UILabel!

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
    @IBOutlet private weak var shortInfoContainerView: UIView!

    var viewModel: ViewModel? {
        didSet {
            guard let requireViewModel = viewModel else { return }

            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }

                self.reloadUI(with: requireViewModel)
            }
        }
    }

    weak var delegate: DetailViewControllerWithScrollViewDelegate?

    private let gradient = CAGradientLayer()
    private let duration = 0.25

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        setupUI()

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

    func checkForDataAvailability(with viewModel: ViewModel) {
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
        staticHoursLabel.text = "HoursLabelText".localized()
        staticPhoneLabel.text = "PhoneLabelText".localized()
        staticWebsiteLabel.text = "WebSiteLabelText".localized()
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

    func configureBestPhotoContainerView(with viewModel: ViewModel) {
        imageView.kf.setImage(with: viewModel.imageURL,
                              placeholder: UIImage(named: "img_placeholder"),
                              options: [.transition(.fade(1.0))],
                              progressBlock: nil)
        gradientSetup()
        venueNameLabel.text = viewModel.nameVenueAndPrice
    }

    func configureShortInfo(with viewModel: ViewModel) {

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
