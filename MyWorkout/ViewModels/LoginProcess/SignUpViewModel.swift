//
//  SignUpViewModel.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/4/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import Foundation
import Firebase

struct SignUpViewModel{
    
    var userEmail: String = ""
    var userPassword: String = ""
    var confirmPassword: String = ""
    var createUser: (){
        get{
            return UserAccount.createUser(withEmail: self.userEmail, password: self.userPassword)
        }
    }
}
