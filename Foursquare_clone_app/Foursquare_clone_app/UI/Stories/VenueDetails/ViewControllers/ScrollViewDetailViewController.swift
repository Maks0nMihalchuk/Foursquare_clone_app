//
//  ViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 21.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol ScrollViewDetailViewControllerDelegate: class {
    func scrollViewDetailViewController(_ viewController: ScrollViewDetailViewController,
                                        didTapFullScreenImage button: UIButton,
                                        with image: UIImage,
                                        model: BestPhotoViewModel)
    func scrollViewDetailViewController(_ viewController: ScrollViewDetailViewController,
                                        didTapBack button: UIButton)
    func scrollViewDetailViewController(_ viewController: ScrollViewDetailViewController,
                                        didTapShowMap button: UIButton,
                                        with viewModel: ShortInfoViewModel)
    func scrollViewDetailViewController(_ viewController: ScrollViewDetailViewController,
                                        didShowAlertError error: Bool)
}

class ScrollViewDetailViewController: UIViewController {

    @IBOutlet private weak var fullScreenButtonHeight: NSLayoutConstraint!
    @IBOutlet private weak var bestPhotoContainerView: UIView!
    @IBOutlet private weak var bestPhotoHeight: NSLayoutConstraint!
    @IBOutlet private weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    var networking: NetworkManager?
    var venueID = String()
    private var dataModel: DetailVenueModel? {
        didSet {
            guard let requireDataModel = dataModel else { return }

            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }

                self.bestPhotoView?.viewModel = BestPhotoViewModel(dataModel: requireDataModel)
                self.shortInfoView?.viewModel = ShortInfoViewModel(dataModel: requireDataModel)
                self.hoursView?.viewModel = HoursViewModel(dataModel: requireDataModel)
                self.contactView?.viewModel = ContactViewModel(dataModel: requireDataModel)
                self.setupScrollView()
            }
        }
    }

    weak var delegate: ScrollViewDetailViewControllerDelegate?

    private let duration = 0.25
    private let spacing: CGFloat = 26
    private let redViewSize: CGFloat = 250
    private var contentViewSizeConstant: CGFloat = 0
    private let transform = CGAffineTransform(rotationAngle: .zero)
    private var bestPhotoView: BestPhotoView?
    private var shortInfoView: ShortInfoView?
    private var hoursView: HoursView?
    private var contactView: ContactView?
    private var redView: RedView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupBestPhotoView()
        setupShortInfoView()
        setupHoursView()
        setupContactView()
        setupRedView()
        layoutSetup()
        loadData()
    }

    @IBAction func screenCloseButtonPressed(_ sender: UIButton) {
        delegate?.scrollViewDetailViewController(self, didTapBack: sender)
    }

    @IBAction func fullScreenDisplayButtonPressed(_ sender: UIButton) {
        guard
            let image = bestPhotoView?.didTransferImage(),
            let model = bestPhotoView?.viewModel
        else { return }

        delegate?.scrollViewDetailViewController(self,
                                                     didTapFullScreenImage: sender,
                                                     with: image,
                                                     model: model)
    }
}

// MARK: - ShortInfoViewDelegate
extension ScrollViewDetailViewController: ShortInfoViewDelegate {
    func shortInfoView(_ view: ShortInfoView,
                       didTapShowMapButton button: UIButton, with model: ShortInfoViewModel) {
        delegate?.scrollViewDetailViewController(self, didTapShowMap: button, with: model)
    }
}

// MARK: - HoursViewDelegate
extension ScrollViewDetailViewController: HoursViewDelegate {
    func hoursView(_ view: HoursView,
                   didTapChangeStateButton button: UIButton,
                   detailHours stackView: UIStackView) {
        let state = checkState(isHidden: stackView.isHidden)
        UIView.animate(withDuration: duration) {
            button.imageView?.transform = state == HoursTableCallState.decomposed
                ? self.transform.rotated(by: .pi)
                : self.transform.rotated(by: .zero)
            stackView.isHidden = !stackView.isHidden
        }
    }
}

// MARK: - Load data
private extension ScrollViewDetailViewController {

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
                                            }
                                        } else {
                                            DispatchQueue.main.async {
                                                self.setupActivityIndicator(isHidden: false)
                                                self.delegate?.scrollViewDetailViewController(self,
                                                                                              didShowAlertError: true)
                                            }
                                        }
        })
    }
}

// MARK: - SetupUI
private extension ScrollViewDetailViewController {

    func setupNavBar() {
        navigationController?.isNavigationBarHidden = true
    }

    func setupBestPhotoView() {
        bestPhotoView = UIView.fromNib() as BestPhotoView
        bestPhotoView?.setupUI()
        bestPhotoView?.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupShortInfoView() {
        shortInfoView = UIView.fromNib() as ShortInfoView
        shortInfoView?.delegate = self
        shortInfoView?.setupUI()
        shortInfoView?.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupHoursView() {
        hoursView = UIView.fromNib() as HoursView
        hoursView?.delegate = self
        hoursView?.setupUI()
        hoursView?.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupContactView() {
        contactView = UIView.fromNib() as ContactView
        contactView?.setupUI()
        contactView?.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupRedView() {
        redView = UIView.fromNib() as RedView
        redView?.setupUI()
        redView?.translatesAutoresizingMaskIntoConstraints = false
    }

    func layoutSetup() {
        guard
            let photoView = bestPhotoView,
            let shortInfo = shortInfoView,
            let hoursView = hoursView,
            let contactView = contactView,
            let redView = redView
        else { return }

        bestPhotoContainerView.addSubview(photoView)
        contentView.addSubview(shortInfo)
        contentView.addSubview(hoursView)
        contentView.addSubview(contactView)
        contentView.addSubview(redView)

        bestPhotoHeight.constant = photoView.bounds.height

        contentViewSizeConstant = shortInfo.bounds.height
            + spacing + hoursView.bounds.height
            + spacing + contactView.bounds.height
            + spacing + redView.bounds.height

        contentViewHeight.constant = contentViewSizeConstant

        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: bestPhotoContainerView.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: bestPhotoContainerView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: bestPhotoContainerView.trailingAnchor),
            photoView.bottomAnchor.constraint(equalTo: bestPhotoContainerView.bottomAnchor),
            shortInfo.topAnchor.constraint(equalTo: contentView.topAnchor),
            shortInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shortInfo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hoursView.topAnchor.constraint(equalTo: shortInfo.bottomAnchor, constant: spacing),
            hoursView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hoursView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contactView.topAnchor.constraint(equalTo: hoursView.bottomAnchor, constant: spacing),
            contactView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contactView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            redView.topAnchor.constraint(equalTo: contactView.bottomAnchor, constant: spacing),
            redView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            redView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            redView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        setupScrollView()
        setupHeightfullScreenButton()
    }

    func setupScrollView() {
        scrollView.contentInset.top = bestPhotoHeight.constant
    }

    func setupHeightfullScreenButton() {
        let window = UIApplication.shared.windows[0]
        fullScreenButtonHeight.constant = bestPhotoContainerView.bounds.height - window.safeAreaInsets.top
    }

    func checkState(isHidden: Bool) -> HoursTableCallState {
        return isHidden ? .decomposed : .folded
    }
}
