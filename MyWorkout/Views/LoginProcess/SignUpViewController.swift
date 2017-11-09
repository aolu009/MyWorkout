//
//  SignUpViewController.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/3/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var secndpasswordTextfield: UITextField!
    
    var viewModel = SignUpViewModel()
    var createUser: ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
        createUser = viewModel.createUser
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    private func setupBinding(){
        emailTextfield.reactive.continuousTextValues.observeValues { (str) in
            guard let email = str else{return}
            self.viewModel.userEmail = email
        }
        passwordTextfield.reactive.continuousTextValues.observeValues { (str) in
            guard let password = str else{return}
            self.viewModel.userPassword = password
        }
        secndpasswordTextfield.reactive.continuousTextValues.observeValues { (str) in
            guard let secndpassword = str else{return}
            self.viewModel.confirmPassword = secndpassword
        }
    }
    
}
