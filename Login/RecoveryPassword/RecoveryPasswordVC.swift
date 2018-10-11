//
//  RecoveryPasswordVCViewController.swift
//  AireFresco
//
//  Created by mac on 6/26/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RecoveryPasswordVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var emailTextField: UnderlinedTextField!
    @IBOutlet private weak var checkCorrectMailImage: UIImageView!
    var viewModel = RecoveryPasswordViewModel()
    var router: RecoveryPasswordRouter!
    let disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavVC()
        setUpErrorLabel()
        router =  RecoveryPasswordRouter(navigationController: navigationController ?? UINavigationController())
        
        //MARK: RxSwift
        _ = viewModel.isNotCorrect.bind(to: checkCorrectMailImage.rx.isHidden)
        emailTextField.rx.text.map { $0 ?? ""}.bind(to: viewModel.emailText).disposed(by: disposeBag)
        
        _ = viewModel.isResetObserver.bind(onNext: { [unowned self] isReset in
            if isReset {
                self.router.routeToRecoveryPasswordConfirmation(self.emailTextField.text ?? "")
            } else {
                self.makeErrorLabelAttriText()
            }
        }).disposed(by: disposeBag)
        
        emailTextField.rx.controlEvent([.editingDidBegin, .editingChanged])
            .asObservable()
            .subscribe(onNext: { _ in
                self.emailTextField.setBottomLine(color: UIColor.AppColors.activeIcons, height: 1.5)
                self.errorLabel.text = ""
            }).disposed(by: disposeBag)
    }
    
    // MARK: - IBActions
    @IBAction func recoverPasswordButton(_ sender: UIButton) {
        viewModel.resetPassword()
    }
    
    private func setUpNavVC() {
        navigationItem.backBarButtonItem = UIBarButtonItem.customBackButton
        navigationItem.title = "Recordar contraseña"
    }
}

// MARK: - Error message
extension RecoveryPasswordVC {
    private func setUpErrorLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        errorLabel.isUserInteractionEnabled = true
        errorLabel.addGestureRecognizer(tap)
    }
    
    @objc func tapFunction(gesture: UITapGestureRecognizer) {
        let text = (errorLabel.text)!
        let createRange = (text as NSString).range(of: "Crea una cuenta.")
        
        if gesture.didTapAttributedTextInLabel(label: errorLabel, inRange: createRange) {
            self.router.routeToRegistration()
        } else {
            print("Tapped none")
        }
    }
    
    private func makeErrorLabelAttriText() {
        emailTextField.setBottomLine(color: UIColor.AppColors.errorMessage)
        
        errorLabel.text = "La dirección de email no está registrada. Puedes intentarlo de nuevo o Crea una cuenta."
        let text = (errorLabel.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        
        let range1 = (text as NSString).range(of: "Crea una cuenta.")
        
        underlineAttriString.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range1)
        
        errorLabel.attributedText = underlineAttriString
    }
}
