//
//  AlertToCreateNewList.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol AlertDelegate: class {
    func closeButtonPressed (_ sender: AlertToCreateNewList)
    func createListButtonPressed (_ sender: AlertToCreateNewList,
                                  listName: String?,
                                  description: String?,
                                  collaborativeFlag: Bool)
}

class AlertToCreateNewList: UIView {

    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var blueBackgroundImage: UIImageView!
    @IBOutlet private weak var userImage: UIImageView!

    @IBOutlet private weak var listNameTextField: UITextField!
    @IBOutlet private weak var listNameLabel: UILabel!

    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var makeCollaborativeLabel: UILabel!
    @IBOutlet private weak var makeCollaborativeDescriptionLabel: UILabel!
    @IBOutlet private weak var collaborationSwitch: UISwitch!
    @IBOutlet private weak var createListButton: UIButton!

    weak var delegate: AlertDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        listNameTextField.delegate = self
        descriptionTextField.delegate = self
        setupButton()
        setupTextField()
        setupLabel()
        setupImage()
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        delegate?.closeButtonPressed(self)
    }

    @IBAction func createListButtonPressed (_ sender: UIButton) {
        delegate?.createListButtonPressed(self,
                                          listName: listNameTextField.text,
                                          description: descriptionTextField.text,
                                          collaborativeFlag: collaborationSwitch.isOn)
    }
}
// MARK: - Setup alert elements
private extension AlertToCreateNewList {
    func setupButton () {
        createListButton.setTitle("AlertToCreateNewList.CreateListButtonTitle".localized(),
                                  for: .normal)
        cancelButton.setTitle("AlertToCreateNewList.CancelButtonTitle".localized(),
                              for: .normal)
    }

    func setupTextField () {
        listNameTextField.placeholder = "AlertToCreateNewList.ListNameTextFieldPlaceholder".localized()
        descriptionTextField.placeholder = "AlertToCreateNewList.DescriptionTextFieldPlaceholder".localized()
    }
    func setupLabel () {
        listNameLabel.text = "AlertToCreateNewList.ListNameLabelText".localized()
        descriptionLabel.text = "AlertToCreateNewList.DescriptionLabelText".localized()
        makeCollaborativeLabel.text = "AlertToCreateNewList.MakeCollaborativeLabelText".localized()
        makeCollaborativeDescriptionLabel.text = "AlertToCreateNewList.MakeCollaborativeDescriptionLabel".localized()
    }

    func setupImage () {
        blueBackgroundImage.image = UIImage(named: "listsCellBackground")?.cropCornerOfImage(by: .bottomLeftCorner)
        blueBackgroundImage.layer.cornerRadius = 5
        blueBackgroundImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        userImage.image = UIImage(named: "userImageDefault")
    }
}
extension AlertToCreateNewList: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
