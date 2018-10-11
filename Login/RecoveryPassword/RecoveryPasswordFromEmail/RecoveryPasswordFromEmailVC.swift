//
//  RecoveryPasswordFromEmailVC.swift
//  AireFresco
//
//  Created by Orest Patlyka on 8/29/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class RecoveryPasswordFromEmailVC: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var newPasswordTextField: UnderlinedTextField!
    @IBOutlet weak var confirmationNewPasswordTextField: UnderlinedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.addShadow()
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 10.0
    }
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
