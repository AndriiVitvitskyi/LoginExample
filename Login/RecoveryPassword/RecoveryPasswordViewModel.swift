//
//  RecoveryPasswordViewModel.swift
//  AireFresco
//
//  Created by mac on 7/5/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import RxSwift

final class RecoveryPasswordViewModel {
    
    var isReset = Variable<Bool>(false)
    var emailText = Variable<String>("")//.asObservable().bind { value in
//        print(value)
//    }
    var passText = Variable<String>("")
    
    lazy var isResetObserver: Observable<Bool> = self.isReset.asObservable().skip(1)

    lazy var isNotCorrect: Observable<Bool> = self.emailText.asObservable().skip(1).map { $0.isNotValidEmail() }
    
    func resetPassword() {
        User.resetPassword(emailText.value) { [weak self] reset in
            self?.isReset.value = reset
        }
    }
}
