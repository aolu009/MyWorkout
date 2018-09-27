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
        
        //let vc1 = TrainingContainerViewController(nibName: "TrainingContainerViewController", bundle: nil)
        //vc1.containerViewController = TrainViewController(nibName: "TrainViewController", bundle: nil)
        //vc1.lowerContainerViewController = TrainHistoryViewController(nibName: "TrainHistoryViewController", bundle: nil)
        
        
        
        let vc0 = TrainHistoryViewController(nibName: "TrainHistoryViewController", bundle: nil) as UIViewController
        let vc1 = BodyViewController        (nibName: "BodyViewController"        , bundle: nil) as UIViewController
        let vc2 = SleepViewController       (nibName: "SleepViewController"       , bundle: nil) as UIViewController
        let vc3 = ProfileViewController     (nibName: "ProfileViewController"     , bundle: nil) as UIViewController
        
        let vc = TrainingContainerViewController(nibName: "TrainingContainerViewController", bundle: nil)
        vc.viewControllers = [vc0,vc1,vc2,vc3]
        
        let historyViewController = vc.viewControllers[0] as! TrainHistoryViewController
        historyViewController.delegate = vc
        
        let trainViewController = TrainViewController(nibName: "TrainViewController", bundle: nil)
        trainViewController.delegate = vc
        
        vc.containerViewController = trainViewController
        vc.lowerContainerViewController = historyViewController
        
        // TODO: Check if below needs to be deleted.
//        let frame = UIScreen.main.bounds
//        self.window = UIWindow(frame: frame)
//        self.window?.rootViewController = vc as UIViewController
//        self.window?.makeKeyAndVisible()
        
        present(vc, animated: true, completion: nil)
        
    }
    
    fileprivate func setupBinding(){
        
        //emailTextfield.becomeFirstResponder()
        
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

