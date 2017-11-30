//
//  ViewController.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/3/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//
// TODO: Forgot Password/Account
import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    fileprivate var viewModel = LoginViewModel()
    var login: ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    
    @IBAction func onLogin(_ sender: Any) {
        // Start login process
        login = viewModel.signingIn
    }
    
    

    @IBAction func onSignUp(_ sender: Any) {
        // Present SignUpViewController
        signUp()
    }
    
    // TODO: Present Login fail warning
    /**
    Present Login fail warning
     */
    fileprivate func presentLoginFail(){
        
    }
    /**
    Present SignUpViewController
     */
    fileprivate func signUp(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as UIViewController
        present(signUpViewController, animated: true, completion: nil)
    }
    /**
     Present MainTabViewController
     */
    fileprivate func goToMainTabView(){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainTabViewController = storyboard.instantiateViewController(withIdentifier: "MainTabViewController") as! UITabBarController
        
        let vc1 = TrainingContainerViewController(nibName: "TrainingContainerViewController", bundle: nil)
        vc1.containerViewController = TrainViewController(nibName: "TrainViewController", bundle: nil)
        vc1.lowerContainerViewController = TrainHistoryViewController(nibName: "TrainHistoryViewController", bundle: nil)
        
        present(vc1, animated: true, completion: nil)
    }
    
    fileprivate func setupBinding(){
        
        emailTextfield.becomeFirstResponder()
        
        viewModel.signedIn.producer.startWithValues { (goToMainView) in
            guard goToMainView else {self.presentLoginFail(); return}
            self.goToMainTabView()
        }
        
        emailTextfield.reactive.continuousTextValues.observeValues { (str) in
            guard let email = str else {return}
            self.viewModel.userEmail = email
        }
        
        passwordTextfield.reactive.continuousTextValues.observeValues { (str) in
            guard let password = str else {return}
            self.viewModel.userPassword = password
        }
    }
    
}

