//
//  RecoveryPasswordRouter.swift
//  AireFresco
//
//  Created by mac on 7/5/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

final class RecoveryPasswordRouter: Router {
    
    func routeToRecoveryPasswordConfirmation(_ email: String) {
        let vc = UIStoryboard.RecoveryPassword.recoveryPasswordConfirmation as! RecoveryPasswordConfirmationVC
        vc.email = email
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToRegistration() {
         navigationController?.popToRootViewController(animated: true)
    }
}
