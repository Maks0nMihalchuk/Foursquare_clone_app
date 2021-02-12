//
//  AlertToCreateNewList.swift
//  Foursquare_clone_app
//
//  Created by maks on 09.01.2021.
//  Copyright © 2021 maks. All rights reserved.
//

import UIKit

protocol CreateNewListAlertDelegate: class {
    func createNewListAlertDidEndInteraction(_ alertToCreateNewList: CreateNewListAlert)
    func createNewListAlert(_ alertToCreateNewList: CreateNewListAlert,
                            createListWith name: String?,
                            description: String?,
                            collaborativeFlag: Bool)
}

class CreateNewListAlert: UIView {

    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var userImage: UIImageView!

    @IBOutlet private weak var listNameTextField: UITextField!
    @IBOutlet private weak var listNameLabel: UILabel!

    @IBOutlet private weak var descriptionTextField: UITextField!
    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var makeCollaborativeLabel: UILabel!
    @IBOutlet private weak var makeCollaborativeDescriptionLabel: UILabel!
    @IBOutlet private weak var collaborationSwitch: UISwitch!
    @IBOutlet private weak var createListButton: UIButton!

    weak var delegate: CreateNewListAlertDelegate?

    func setupUI() {
        setupCornerRadiusForAlert()
        listNameTextField.delegate = self
        descriptionTextField.delegate = self
        setupButton()
        setupTextField()
        setupLabel()
        setupImage()
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        delegate?.createNewListAlertDidEndInteraction(self)
    }

    @IBAction func createListButtonPressed(_ sender: UIButton) {
        delegate?.createNewListAlert(self,
                                        createListWith: listNameTextField.text,
                                        description: descriptionTextField.text,
                                        collaborativeFlag: collaborationSwitch.isOn)
    }
}

// MARK: - UITextFieldDelegate
extension CreateNewListAlert: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

// MARK: - Setup alert elements
private extension CreateNewListAlert {

    func setupCornerRadiusForAlert() {
        layer.cornerRadius = 5
    }

    func setupButton() {
        createListButton.setTitle("CreateNewListAlert.CreateListButtonTitle".localized(),
                                  for: .normal)
        cancelButton.setTitle("CreateNewListAlert.CancelButtonTitle".localized(),
                              for: .normal)
    }

    func setupTextField() {
        listNameTextField.placeholder = "CreateNewListAlert.ListNameTextFieldPlaceholder".localized()
        descriptionTextField.placeholder = "CreateNewListAlert.DescriptionTextFieldPlaceholder".localized()
    }
    func setupLabel() {
        listNameLabel.text = "CreateNewListAlert.ListNameLabelText".localized()
        descriptionLabel.text = "CreateNewListAlert.DescriptionLabelText".localized()
        makeCollaborativeLabel.text = "CreateNewListAlert.MakeCollaborativeLabelText".localized()
        makeCollaborativeDescriptionLabel.text = "CreateNewListAlert.MakeCollaborativeDescriptionLabel".localized()
    }

    func setupImage() {
        topImageView.image = UIImage(named: "listsCellBackground")?.cropCornerOfImage(by: .bottomLeftCorner)
        topImageView.layer.cornerRadius = 5
        topImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        userImage.image = UIImage(named: "userImageDefault")
    }
}
