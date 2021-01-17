//
//  HoursTableCell.swift
//  Foursquare_clone_app
//
//  Created by maks on 16.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol HoursTableCellDelegate: class {
    func hoursTableCell (_ hoursTableCell: HoursTableCell,
                         displayDetailedInfo byPressedButton: Bool,
                         heightView: NSLayoutConstraint,
                         stockHeightView: CGFloat)
}

class HoursTableCell: UITableViewCell {

    @IBOutlet private weak var heightView: NSLayoutConstraint!
    @IBOutlet private weak var detailHoursButton: UIButton!
    @IBOutlet private weak var hoursLabel: UILabel!
    @IBOutlet private weak var hoursStatusLabel: UILabel!
    @IBOutlet private weak var detailHoursInfoStackView: UIStackView!
    @IBOutlet private weak var daysLabel: UILabel!
    @IBOutlet private weak var hoursDetailLabel: UILabel!

    weak var delegate: HoursTableCellDelegate?

    static let identifier = "HoursTableCell"

    private var stockHeight: CGFloat = 0
    private var isDisplay = false

    override func awakeFromNib() {
        super.awakeFromNib()
        stockHeight = heightView.constant
    }

    static func nib () -> UINib {
        return UINib(nibName: "HoursTableCell", bundle: nil)
    }

    func configure (hoursStatus: String) {
        hoursStatusLabel.text = hoursStatus
    }

    @IBAction func detailHoursButtonPressed (_ sender: UIButton) {

        delegate?.hoursTableCell(self, displayDetailedInfo: isDisplay, heightView: heightView, stockHeightView: stockHeight)
//        UIView.animate(withDuration: 0.25) {
//            if !self.buttonPressed {
//                self.heghtView.constant = 100
//                self.buttonPressed = !self.buttonPressed
//            } else {
//                self.heghtView.constant = self.stockHeight
//                self.buttonPressed = !self.buttonPressed
//            }
//            self.detailHoursInfoStackView.isHidden = !self.detailHoursInfoStackView.isHidden
//            self.superview?.layoutIfNeeded()
//        }
    }
}
