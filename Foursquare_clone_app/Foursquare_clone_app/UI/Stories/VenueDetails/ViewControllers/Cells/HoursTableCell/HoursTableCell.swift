//
//  HoursTableCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 16.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol HoursTableCellDelegate: class {
    func hoursTableViewCell(_ cell: HoursTableCell,
                            didTapChangeState button: UIButton,
                            to state: HoursTableCallState.Type)
}

class HoursTableCell: UITableViewCell {

    @IBOutlet private weak var detailHoursButton: UIButton!
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var hoursStatusLabel: UILabel!
    @IBOutlet private weak var detailHoursInfoStackView: UIStackView!
    @IBOutlet private weak var daysLabel: UILabel!
    @IBOutlet private weak var hoursDetailLabel: UILabel!

    weak var delegate: HoursTableCellDelegate?

    var contentModel: HoursCellModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupHoursLabel()
    }

    func configure(with content: HoursCellModel) {
        detailHoursInfoStackView.isHidden = content.state
        detailHoursButton.isHidden = hoursDetailLabel.text!.isEmpty
        hoursStatusLabel.text = content.hoursStatus
        daysLabel.text = content.detailHours.days
        hoursDetailLabel.text = content.detailHours.detailHours
    }

    @IBAction func detailHoursButtonPressed(_ sender: UIButton) {
        delegate?.hoursTableViewCell(self,
                                     didTapChangeState: sender,
                                     to: HoursTableCallState.self)
    }
}

// MARK: - setup HoursLabel
private extension HoursTableCell {

    func setupHoursLabel() {
        hoursLabel.text = "HoursLabelText".localized()
    }
}
