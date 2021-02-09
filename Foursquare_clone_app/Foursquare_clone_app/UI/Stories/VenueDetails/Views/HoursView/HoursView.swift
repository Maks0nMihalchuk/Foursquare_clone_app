//
//  HoursVIew.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.02.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import Foundation
import UIKit

class HoursView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var hoursVanueLabel: UILabel!
    @IBOutlet private weak var detailDaysLabel: UILabel!
    @IBOutlet private weak var detailHoursLabel: UILabel!
    @IBOutlet private weak var detailHoursButton: UIButton!

    var viewModel: HoursViewModel? {
        didSet {
            guard let requireViewModel = viewModel else { return }

            reloadUI(with: requireViewModel)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - setupUI
private extension HoursView {

    func commonInit() {
        let nibName = String(describing: HoursView.self)
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func setupUI() {
        hoursLabel.text = "HoursLabelText".localized()
        hoursVanueLabel.text = "LabelTextPlaceholder".localized()
        detailDaysLabel.text = "LabelTextPlaceholder".localized()
        detailHoursLabel.text = "LabelTextPlaceholder".localized()
    }

    func reloadUI(with viewModel: HoursViewModel) {
        hoursVanueLabel.text = viewModel.hoursStatus
        detailDaysLabel.text = viewModel.detailDays
        detailHoursLabel.text = viewModel.detailHours
    }
}
