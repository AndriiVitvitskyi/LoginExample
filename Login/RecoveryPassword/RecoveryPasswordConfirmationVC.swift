//
//  RecoveryPasswordConfirmationVC.swift
//  AireFresco
//
//  Created by Orest Patlyka on 6/26/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

final class RecoveryPasswordConfirmationVC: UIViewController {
    
    // MARK: - Properties
    var email: String?
    
    // MARK: - IBOutlets
    @IBOutlet private weak var emailLabel: UILabel!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLabel.text = email ?? ""
    }

    // MARK: - IBActions
    @IBAction private func confirmButton(_ sender: UIButton) {
        // TODO: - Route to logIn screen
    }
}
