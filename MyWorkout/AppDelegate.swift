//
//  AppDelegate.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/3/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
// TODO: Clean up code for initiating VC

import UIKit
import FirebaseCore
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let _ = Bluetooth.manage
        
        if Auth.auth().currentUser != nil{
            
            let vc0 = TrainHistoryViewController(nibName: "TrainHistoryViewController", bundle: nil) as UIViewController
            let vc1 = BodyViewController(nibName: "BodyViewController", bundle: nil) as UIViewController
            let vc2 = SleepViewController(nibName: "SleepViewController", bundle: nil) as UIViewController
            let vc3 = ProfileViewController(nibName: "ProfileViewController", bundle: nil) as UIViewController
            
            let vc = TrainingContainerViewController(nibName: "TrainingContainerViewController", bundle: nil)
            vc.viewControllers = [vc0,vc1,vc2,vc3]
            
            let historyViewController = vc.viewControllers[0] as! TrainHistoryViewController
            historyViewController.delegate = vc
            
            let trainViewController = TrainViewController(nibName: "TrainViewController", bundle: nil)
            trainViewController.delegate = vc
            
            vc.containerViewController = trainViewController
            vc.lowerContainerViewController = historyViewController
            
            // TODO: Check if below needs to be deleted.
            let frame = UIScreen.main.bounds
            self.window = UIWindow(frame: frame)
            self.window?.rootViewController = vc as UIViewController
            self.window?.makeKeyAndVisible()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

