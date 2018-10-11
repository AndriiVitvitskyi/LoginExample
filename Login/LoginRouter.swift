//
//  LoginRouter.swift
//  AireFresco
//
//  Created by Andrii Vitvitskyi on 6/5/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

final class LoginRouter: Router {
    
    func routeToMain() {
        var vc: UIViewController!
        vc = UIStoryboard.LoadAnimation.loadAnimation
        navigationController = UINavigationController(rootViewController: vc)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
    
    func routeToRegistration() {
        let vc = UIStoryboard.Registration.main
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func routeToRecoveryPassword() {
        let vc = UIStoryboard.Login.recoveryPassword
        navigationController?.pushViewController(vc, animated: true)
    }
}
