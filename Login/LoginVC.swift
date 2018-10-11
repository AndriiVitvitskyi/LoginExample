//
//  LoginVC.swift
//  AireFresco
//
//  Created by Andrii Vitvitskyi on 6/5/18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FacebookLogin
import GoogleSignIn

final class LoginVC: UIViewController {
    
    //MARK: - Properties
    private var router: LoginRouter!
    private var loginViewModel: LoginViewModel!
    private let dispaseBag = DisposeBag()
    private var appRouter: AppRouter!

    //MARK: - IBOutlets
    @IBOutlet private weak var emailTextField: UnderlinedTextField!
    @IBOutlet private weak var passwordTextField: UnderlinedTextField!
    @IBOutlet private weak var errorLabel: UILabel!
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavVC()
        setUpErrorLabel()
        
        router = LoginRouter(navigationController: navigationController ?? UINavigationController())
        
        //MARK: RxSwift
        loginViewModel = LoginViewModel()
        emailTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.emailText).disposed(by: dispaseBag)
        passwordTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.passwordText).disposed(by: dispaseBag)
        
        _ = loginViewModel.incorrectEmailObservable.bind(onNext: { [unowned self] incorrect in
            if incorrect {
                self.showAlertMessageWithTitleOkButton("Incorect email field")
            }
        }).disposed(by: dispaseBag)
        
        _ = loginViewModel.incorrectPasswordObservable.bind(onNext: { [unowned self] incorrectPassword in
            if incorrectPassword {
                self.showAlertMessageWithTitleOkButton("Incorect password field")
            }
        }).disposed(by: dispaseBag)

        _ = loginViewModel.loginObservable.bind(onNext: { [unowned self] isLogin in
            if isLogin {
                self.router.routeToMain()
            } else {
                self.makeErrorLabelAttriText()
            }
        }).disposed(by: dispaseBag)
        
        emailTextField.rx.controlEvent([.editingDidBegin]).asObservable().subscribe(onNext: { _ in
            self.passwordTextField.setBottomLine()
            self.errorLabel.text = ""
        }).disposed(by: dispaseBag)
        
        passwordTextField.rx.controlEvent([.editingDidBegin]).asObservable().subscribe(onNext: { _ in
            self.emailTextField.setBottomLine()
            self.errorLabel.text = ""
        }).disposed(by: dispaseBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Methods
    private func setUpNavVC() {
        navigationItem.title = "Acceder"
        navigationItem.backBarButtonItem = UIBarButtonItem.customBackButton
        navigationController?.navigationBar.addShadowWithTranslucentNavBar()
        
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "arrow-back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "arrow-back")
    }
    
    //MARK: - IBActions
    @IBAction func login(_ sender: UIButton) {
        loginViewModel.tryLogin()
        //router.routeToMain()
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        router.routeToRecoveryPassword()
    }
    
    @IBAction func faceBookLogin(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn(publishPermissions: [.publishPages], viewController: self) { [weak self] loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                print(accessToken.authenticationToken)
                self?.loginViewModel.facebookLogin(accessToken.authenticationToken)
            }
        }
    }
    
    @IBAction func googleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
}

//MARK: GoogleSingIn
extension LoginVC: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            loginViewModel.googleLogin(user.authentication.accessToken)
        }
    }
}

//MARK: - Error message
extension LoginVC {
    private func setUpErrorLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        errorLabel.isUserInteractionEnabled = true
        errorLabel.addGestureRecognizer(tap)
    }
    
    @objc func tapFunction(gesture: UITapGestureRecognizer) {
        let text = (errorLabel.text)!
        let createRange = (text as NSString).range(of: "Crea una cuenta.")
        
        if gesture.didTapAttributedTextInLabel(label: errorLabel, inRange: createRange) {
            router.routeToRegistration()
            print("Tapped Crea una cuenta.")
        } else {
            print("Tapped none")
        }
    }
    
    func makeErrorLabelAttriText() {
        
        emailTextField.setBottomLine(color: UIColor.AppColors.errorMessage)
        
        errorLabel.text = "La dirección de correo o contraseña son incorrectas. Inténtalo de nuevo o Crea una cuenta."
        let text = (errorLabel.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        
        let range1 = (text as NSString).range(of: "Crea una cuenta.")
        let rangeOfFullStr = (text as NSString).range(of: "La dirección de correo o contraseña son incorrectas. Inténtalo de nuevo o Crea una cuenta.")
        
        underlineAttriString.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range1)
        underlineAttriString.addAttribute(.foregroundColor, value: UIColor.AppColors.errorMessage, range: rangeOfFullStr)
        
        errorLabel.attributedText = underlineAttriString
    }
}
