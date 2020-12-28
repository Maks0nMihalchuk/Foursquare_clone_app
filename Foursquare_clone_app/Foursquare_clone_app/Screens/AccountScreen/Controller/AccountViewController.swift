//
//  AccountViewController.swift
//  Foursquare_clone_app
//
//  Created by maks on 28.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!

    private let appearance = UITabBarAppearance()

    override func viewDidLoad() {
        super.viewDidLoad()

        appearance.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearance
    }

    @IBAction func signInButtonPressed(_ sender: UIButton) {

        
    }
}
