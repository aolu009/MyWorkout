//
//  LoginViewModel.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/3/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import Foundation
import Firebase
import ReactiveSwift

struct LoginViewModel{
    
    var userEmail: String = ""
    
    var userPassword: String = ""
    
    var signedIn = UserAccount.userInfo.signedInSignal

    var signingIn: () {
        get{
            return UserAccount.userInfo.signIn(withEmail: self.userEmail, password: self.userPassword)
        }
    }
}

