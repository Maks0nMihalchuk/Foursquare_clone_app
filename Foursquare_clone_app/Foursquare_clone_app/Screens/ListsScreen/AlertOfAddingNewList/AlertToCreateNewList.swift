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
    //func nameOfListIsBeingEntered (textFielld: UITextField)
    func createListButtonPressed (buttonCreate: UIButton)
    func collaborationSwitchAcrion (colloboraticeSwitch: UISwitch)

}

class AlertToCreateNewList: UIView {

    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var blueBackgroundImage: UIImageView!
    @IBOutlet private weak var userImage: UIImageView!

    @IBOutlet private weak var listNameTextField: UITextField!
    @IBOutlet private weak var listNameLabel: UILabel!

    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var makeCollaborativeTextField: UILabel!
    @IBOutlet private weak var makeCollaborativeLabel: UILabel!
    @IBOutlet private weak var collaborationSwitch: UISwitch!
    @IBOutlet private weak var createListButton: UIButton!

    weak var delegate: AlertDelegate?

    func configureAlertImage () {
        blueBackgroundImage.image = UIImage(named: "listsCellBackground")?.cropCornerOfImage()
        userImage.image = UIImage(named: "userImageDefault")
    }

    func connectDelegateForTextFields () {
        listNameTextField.delegate = self
        descriptionTextField.delegate = self
    }

    @IBAction func collaborationSwitchAcrion(_ sender: UISwitch) {
        delegate?.collaborationSwitchAcrion(colloboraticeSwitch: sender)
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
