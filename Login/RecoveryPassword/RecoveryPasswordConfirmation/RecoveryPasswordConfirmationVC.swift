//
//  File.swift
//  AireFresco
//
//  Created by mac on 7/4/18.
//  Copyright © 2018 mac. All rights reserved.
//
import UIKit

class RecoveryPasswordConfirmationVC: UIViewController {
    
    var email: String?
    
    @IBOutlet private weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = email ?? ""
        navigationItem.title = "Recordar contraseña"
    }
    
    
    @IBAction private func confirmButton(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}

