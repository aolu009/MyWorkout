//  AppDelegate.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/3/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//====================================================================================
/*
 * TODO: Clean up code (Top Priority, finish before starting developing anything else)
 *       |__Documentation for all files under MyWorkout
 *          |__Develope documentation style
 *          |__Documentation syntax for better link/look-up
 *       |__Create a sepatate file for TODO summary(Optional)
 *       |__Create overview file for the app topolog and details...etc
 *       |__Clean Ups
 *          |__Adjust UI codes to see if it can be adapted to all size of devices
 *              |__Replace as many IB constraints with codes as possible
 *              |__Develope constratints code with higher matainability.(Safe area....)
 *          |__Study NSCoder for initiate views/xibs:
 *          |__Clean up warnings for library files, if possible.
 *       |__Learn about new changes regarding Swift4
 * TODO: Develope Reactive(possible solutions: all delegate?? pretocols??)
 *       |__Study Reactive CoCoa/Swift
 *          |__Clean up warning, if possible(via workarounds)
 *       |__Study how to develope library
 *       |__Develope reactive independently
 * TODO: Pending functions:
 *       |__LaunchingScreen: Make it animated/video
 *       |__Logins:
 *          |__Muti-User Login:
 *             |__Keep lists of user logged in before
 *             |__Use gesture to remove unwanted
 *          |__FaceID login
 *       |__Sleep tracking:
 *       |__Profiles:
 *       |__Body???:
 * TODO: Possible feature:
 *       |__Diet tracking(with cal/food type??)
 *       |__Shape tracking
 *       |__Social Media
 *       |__Track bode composition with OMRON(?) Scale, if provided that it has releasing for developer
 *       |__Funtional trainging progress/result tracking(vertical leap, sprint velocity....etc)
 * TODO: Develope template objects(App object/customize objects)
 * TODO: Adapt cool C/C++ library
 * TODO: Backend node.js management
 *       |__google server
 *       |__AWS
 */
//====================================================================================

import UIKit
import FirebaseCore
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let _ = Bluetooth.manage
        launchInitViews()
        
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
    /**
     Launching Home view if there is already a logged in user, else present login/sign_up view
    */
    func launchInitViews(){
        //TODO: Logout.
        if Auth.auth().currentUser != nil{
            
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
            let frame = UIScreen.main.bounds
            self.window = UIWindow(frame: frame)
            self.window?.rootViewController = vc as UIViewController
            self.window?.makeKeyAndVisible()
        }
    }

}

