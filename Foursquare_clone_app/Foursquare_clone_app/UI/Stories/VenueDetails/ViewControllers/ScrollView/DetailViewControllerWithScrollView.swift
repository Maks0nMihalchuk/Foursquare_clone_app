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

    @IBOutlet private weak var bestPhotoContainerView: UIView!
    @IBOutlet weak var bestPhotoHeight: NSLayoutConstraint!
    @IBOutlet private weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!

    var dataModel: DetailVenueModel? {
        didSet {
            guard let requireDataModel = dataModel else { return }

            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }

                self.bestPhotoView?.viewModel = BestPhotoViewModel(dataModel: requireDataModel)
                self.shortInfoView?.viewModel = ShortInfoViewModel(dataModel: requireDataModel)
                self.hoursView?.viewModel = HoursViewModel(dataModel: requireDataModel)
                self.contactView?.viewModel = ContactViewModel(dataModel: requireDataModel)
            }
        }
    }

    weak var delegate: DetailViewControllerWithScrollViewDelegate?

    private let spacing: CGFloat = 26
    private var contentViewSizeConstant: CGFloat = 0
    private let assemblyView = VenueDetailViewAssembly()
    private var bestPhotoView: BestPhotoView?
    private var shortInfoView: ShortInfoView?
    private var hoursView: HoursView?
    private var contactView: ContactView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBestPhotoView()
        setupShortInfoView()
        setupHoursView()
        setupContactView()
        layoutSetup()
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func screenCloseButtonPressed(_ sender: UIButton) {
        delegate?.detailViewControllerWithScrollView(self, didTapBack: sender)
    }

    @IBAction func fullScreenDisplayButtonPressed(_ sender: UIButton) {

    }
}

// MARK: - SetupUI
private extension DetailViewControllerWithScrollView {

    func setupBestPhotoView() {
        bestPhotoView = assemblyView.assemblyBestPhotoView()
        bestPhotoView?.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupShortInfoView() {
        shortInfoView = assemblyView.assemblyShortInfoView()
        shortInfoView?.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupHoursView() {
        hoursView = assemblyView.assemblyHoursView()
        hoursView?.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupContactView() {
        contactView = assemblyView.assemblyContactView()
        contactView?.translatesAutoresizingMaskIntoConstraints = false
    }

    func layoutSetup() {
        guard
            let photoView = bestPhotoView,
            let shortInfo = shortInfoView,
            let hoursView = hoursView,
            let contactView = contactView
        else { return }

        bestPhotoContainerView.addSubview(photoView)
        contentView.addSubview(shortInfo)
        contentView.addSubview(hoursView)
        contentView.addSubview(contactView)

        bestPhotoHeight.constant = photoView.bounds.height

        contentViewSizeConstant = shortInfo.bounds.size.height
            + spacing
            + hoursView.bounds.size.height
            + spacing
            + contactView.bounds.size.height
            + spacing

        contentViewHeight.constant = contentViewSizeConstant

        NSLayoutConstraint.activate([

            photoView.topAnchor.constraint(equalTo: bestPhotoContainerView.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: bestPhotoContainerView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: bestPhotoContainerView.trailingAnchor),
            photoView.bottomAnchor.constraint(equalTo: bestPhotoContainerView.bottomAnchor),

            shortInfo.topAnchor.constraint(equalTo: contentView.topAnchor),
            shortInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shortInfo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            hoursView.topAnchor.constraint(equalTo: shortInfo.bottomAnchor,
                                           constant: spacing),
            hoursView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hoursView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            contactView.topAnchor.constraint(equalTo: hoursView.bottomAnchor,
                                             constant: spacing),
            contactView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contactView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        setupScrollView()
    }

    func setupScrollView() {
        scrollView.contentInset.top = bestPhotoContainerView.bounds.height
    }

    func setupHeightfullScreenButton() {

    }

    func checkForDataAvailability(with viewModel: ViewModel) {

    }
}
