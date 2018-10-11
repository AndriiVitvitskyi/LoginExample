//
//  LoginViewModel.swift
//  AireFresco
//
//  Created by Andrii Vitvitskyi on 6/12/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol LoginViewModelProtocol {
    var emailText: Variable<String> { get set }
    var passwordText: Variable<String> { get set }
    var loginObservable: Observable<Bool> { get set }
    var isLogin: Variable<Bool> { get set }
    var incorrectEmail: Variable<Bool> { get set }
    var incorrectEmailObservable: Observable<Bool> { get set }
    func tryLogin()
}

final class LoginViewModel: LoginViewModelProtocol {
    var emailText = Variable<String>("")
    var passwordText = Variable<String>("")
    var isLogin = Variable<Bool>(false)
    var incorrectEmail = Variable<Bool>(false)
    var incorrectPassword = Variable<Bool>(false)
    
    lazy var loginObservable: Observable<Bool> = self.isLogin.asObservable().skip(1)
    lazy var incorrectEmailObservable: Observable<Bool> = self.incorrectEmail.asObservable().skip(1)
    lazy var incorrectPasswordObservable: Observable<Bool> = self.incorrectPassword.asObservable().skip(1)
    
//    var textfieldsChanged: Observable<Bool> {
//        return Observable.combineLatest(emailText.asObservable(), passwordText.asObservable()) { email, password in
//            return true
//        }
//    }
//
    
    private func login() {
        let loginBody = LoginBody(email: emailText.value, password: passwordText.value)
        User.login(login: loginBody) { [weak self] (success) in
            self?.isLogin.value = success
        }
    }
    
    func tryLogin() {
        if !emailText.value.isNotValidEmail() {
            if passwordText.value.isValidPassword() {
                login()
            } else {
                incorrectPassword.value = true
            }
        } else {
            incorrectEmail.value = true
        }
    }
    
    func facebookLogin(_ authenticationToken: String) {
        User.faceBookLogin(authenticationToken) { [weak self] isLogin in
            self?.isLogin.value = isLogin
        }
    }
    
    func googleLogin(_ access_token: String) {
        User.googleLogin(access_token) { [weak self] isLogin in
            self?.isLogin.value = isLogin
        }
    }
}
