//
//  TrainingContainerViewController.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/5/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class TrainViewController: UIViewController {

    
    
    @IBOutlet weak var trainNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func didTapAddExercise(_ sender: Any) {
        // Present exercisePickerViewController
        presentExercisePickerViewController()
    }
    
    @IBAction func onSwipe(_ swipeGesture: UISwipeGestureRecognizer) {
        // performSwipeAnimation()
    }
    
    func performSwipeAnimation(){
//        UIView.animate(withDuration: 0, animations: {
//            <#code#>
//        }) { (<#Bool#>) in
//            <#code#>
//        }
    }
    func presentExercisePickerViewController(){
//        var phototaker: exercisePickerViewController?
//        exercisePickerViewController = exercisePickerViewController(nibName: "exercisePickerViewController", bundle: nil)
//        exercisePickerViewController?.view.frame = self.view.bounds
//        let vc = exercisePickerViewController as? UIViewController
//        present(vc, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "TrainViewController", bundle: nil)
        initController()
    }
    
    override init(nibName: String? , bundle: Bundle?) {
        super.init(nibName: "TrainViewController", bundle: nil)
        initController()
    }
    
    func initController() {
        let nib = UINib(nibName: "TrainViewController", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        self.trainNameLabel.reactive.text <~ Bluetooth.manage.heartRate.signal
    }
}
