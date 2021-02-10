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
                                            with image: UIImage,
                                            model: BestPhotoViewModel)
    func detailViewControllerWithScrollView(_ viewController: DetailViewControllerWithScrollView,
                                            didTapBack button: UIButton)
}

class DetailViewControllerWithScrollView: UIViewController {

    @IBOutlet weak var fullScreenButtonHeight: NSLayoutConstraint!
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

    private let duration = 0.25
    private let spacing: CGFloat = 26
    private let redViewSize: CGFloat = 250
    private var contentViewSizeConstant: CGFloat = 0
    private let assemblyView = VenueDetailViewAssembly()
    private let transform = CGAffineTransform(rotationAngle: .zero)
    private var bestPhotoView: BestPhotoView?
    private var shortInfoView: ShortInfoView?
    private var hoursView: HoursView?
    private var contactView: ContactView?
    private var redView: RedView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBestPhotoView()
        setupShortInfoView()
        setupHoursView()
        setupContactView()
        setupRedView()
        layoutSetup()
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func screenCloseButtonPressed(_ sender: UIButton) {
        delegate?.detailViewControllerWithScrollView(self, didTapBack: sender)
    }

    @IBAction func fullScreenDisplayButtonPressed(_ sender: UIButton) {
        guard
            let image = bestPhotoView?.didTransferImage(),
            let model = bestPhotoView?.viewModel
        else { return }

        delegate?.detailViewControllerWithScrollView(self,
                                                     didTapFullScreenImage: sender,
                                                     with: image,
                                                     model: model)
    }
}

// MARK: - HoursViewDelegate
extension DetailViewControllerWithScrollView: HoursViewDelegate {
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
        hoursView?.delegate = self
        hoursView?.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupContactView() {
        contactView = assemblyView.assemblyContactView()
        contactView?.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupRedView() {
        redView = assemblyView.assemblyRedView()
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
        guard let photoView = bestPhotoView else { return }

        let window = UIApplication.shared.windows[0]
        scrollView.contentInset.top = photoView.bounds.height - window.safeAreaInsets.top
    }

    func setupHeightfullScreenButton() {
        let window = UIApplication.shared.windows[0]
        fullScreenButtonHeight.constant = bestPhotoContainerView.bounds.height - window.safeAreaInsets.top
    }

    func checkState(isHidden: Bool) -> HoursTableCallState {
        return isHidden ? .decomposed : .folded
    }
}
