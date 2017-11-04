//
//  ViewController.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/3/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class LoginViewController: UIViewController {

    var loginInfo: LoginViewModel?
    @IBOutlet weak var emailTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    
    
    @IBAction func onLogin(_ sender: Any) {
    }
    
    

    @IBAction func onSignUp(_ sender: Any) {
        // Present SignUpViewController
        signUp()
    }
    
    //TODO:
    /**
     Present
     **/
    private func signUp(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as UIViewController
        present(signUpViewController, animated: true, completion: nil)
    }
    
    
}

