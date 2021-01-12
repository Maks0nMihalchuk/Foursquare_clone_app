//
//  AlertToCreateNewList.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol AlertDelegate: class {
    func closeButtonPressed (cancelButton: UIButton)
    func createListButtonPressed (buttonCreate: UIButton)
    func collaborationSwitchAction (colloboraticeSwitch: UISwitch)
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

    func configureAlert () {
        self.layer.cornerRadius = 5
        createListButton.setTitle("AlertToCreateNewList.CreateListButtonTitle".localized(),
                                  for: .normal)
        cancelButton.setTitle("AlertToCreateNewList.CancelButtonTitle".localized(),
                              for: .normal)
        listNameLabel.text = "AlertToCreateNewList.ListNameLabelText".localized()
        listNameTextField.placeholder = "AlertToCreateNewList.ListNameTextFieldPlaceholder".localized()
        descriptionLabel.text = "AlertToCreateNewList.DescriptionLabelText".localized()
        descriptionTextField.placeholder = "AlertToCreateNewList.DescriptionTextFieldPlaceholder".localized()
        makeCollaborativeLabel.text = "AlertToCreateNewList.MakeCollaborativeLabelText".localized()
        makeCollaborativeDescriptionLabel.text = "AlertToCreateNewList.MakeCollaborativeDescriptionLabel".localized()

        blueBackgroundImage.image = UIImage(named: "listsCellBackground")?.cropCornerOfImage()
        blueBackgroundImage.layer.cornerRadius = 5
        blueBackgroundImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        userImage.image = UIImage(named: "userImageDefault")
    }

    func connectDelegateForTextFields () {
        listNameTextField.delegate = self
        descriptionTextField.delegate = self
    }

    @IBAction func collaborationSwitchAcrion(_ sender: UISwitch) {
        delegate?.collaborationSwitchAction(colloboraticeSwitch: sender)
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        delegate?.closeButtonPressed(cancelButton: sender)
    }

    @IBAction func createListButtonPressed (_ sender: UIButton) {
        delegate?.createListButtonPressed(buttonCreate: sender)
    }
}
extension AlertToCreateNewList: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        guard let text = textField.text else {
            return
        }

        if textField === listNameTextField {
            configureListOptions[KeyForList.listName.currentKey] = text
        } else {
            configureListOptions[KeyForList.description.currentKey] = text
        }
    }
}
