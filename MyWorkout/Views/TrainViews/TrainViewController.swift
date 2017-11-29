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

class TrainViewController: UIViewController,UIGestureRecognizerDelegate {

    
    
    @IBOutlet weak var trainNameLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var trainingTypeButton: UIButton!
    @IBOutlet weak var addTrainingButton: UIButton!
    
    
    var newButtonA: UIButton!
    var newButtonB: UIButton!
    
    var newCenter =  CGPoint()
    
    
    // TODO: Replace with viewModel data
    var buttonTitle = ["1","2","3","4"]
    private (set) var trainTypeOptionIdx = 0
    
    var panOnTrainTypeButton: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        
        self.newButtonA.center = self.view.center
        self.newButtonB.center = self.view.center
        //self.newButtonC.center = self.view.center
        
        
        self.newButtonB.center.x = self.view.frame.width + self.newButtonB.frame.width/2
        //self.newButtonC.center.x = -self.newButtonC.frame.width/2
        
        
        self.addTrainingButton.layer.cornerRadius = 0.5 * self.addTrainingButton.frame.width
        self.addTrainingButton.layer.borderColor = UIColor.black.cgColor
        self.addTrainingButton.layer.borderWidth = 2
        
        self.heartRateLabel.layer.cornerRadius = 0.5 * self.heartRateLabel.frame.width
        self.heartRateLabel.layer.borderColor = UIColor.black.cgColor
        self.heartRateLabel.layer.borderWidth = 2
    }
    
    
    @IBAction func didTapAddExercise(_ sender: Any) {
        // Present exercisePickerViewController
        presentExercisePickerViewController()
    }
    
    @objc func panOnTrainingTypeButton(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        let originalCenter = self.view.center
        
        let newCenterR = CGPoint(x: 3 * self.view.frame.width/2, y: originalCenter.y)//(self.view.frame.width/2 - self.trainingTypeButton.frame.width/2)
        let newCenterL = CGPoint(x: -self.view.frame.width/2, y: originalCenter.y)
        
        
        var angleRotate: CGFloat! = 0.0
        
        if gesture.state == .began{
            if velocity.x < 0{
                self.newCenter = newCenterR
                if trainTypeOptionIdx < buttonTitle.count - 1{
                    self.newButtonB = newButton(frame: self.trainingTypeButton.frame)
                    self.newButtonB.center = newCenterR
                    self.newButtonB.setTitle(self.buttonTitle[self.trainTypeOptionIdx + 1], for: .normal)
                    self.newButtonB.isHidden = false
                    view.addSubview(self.newButtonB)
                    print(newCenter,newCenterR)
                }else{
                    self.newButtonB = newButton(frame: self.trainingTypeButton.frame)
                    self.newButtonB.center = newCenterR
                    self.newButtonB.setTitle(self.buttonTitle[self.trainTypeOptionIdx], for: .normal)
                    self.newButtonB.isHidden = true
                    view.addSubview(self.newButtonB)
                    
                }
                
            }else if velocity.x > 0{
                self.newCenter = newCenterL
                if trainTypeOptionIdx > 0{
                    self.newButtonB = newButton(frame: self.trainingTypeButton.frame)
                    self.newButtonB.center = newCenterL
                    self.newButtonB.setTitle(self.buttonTitle[self.trainTypeOptionIdx - 1], for: .normal)
                    self.newButtonB.isHidden = false
                    view.addSubview(self.newButtonB)
                }else{
                    self.newButtonB = newButton(frame: self.trainingTypeButton.frame)
                    self.newButtonB.center = newCenterL
                    self.newButtonB.setTitle(self.buttonTitle[self.trainTypeOptionIdx], for: .normal)
                    self.newButtonB.isHidden = true
                    view.addSubview(self.newButtonB)
                }
            }
        }else if gesture.state == .changed{
            angleRotate = 4 * 3.14 * (translation.x/self.view.frame.width)
            
            if velocity.x < 0{
                if trainTypeOptionIdx < buttonTitle.count - 1{
                    self.newButtonA.center.x = originalCenter.x + translation.x
                    self.newButtonB.center.x = newCenter.x + translation.x
                    self.newButtonA.transform = CGAffineTransform(rotationAngle: angleRotate)
                    self.newButtonB.transform = CGAffineTransform(rotationAngle: angleRotate)
                }else{
                    if self.newButtonA.center.x > view.frame.width/5{
                        self.newButtonA.center.x = originalCenter.x + translation.x
                        self.newButtonB.center.x = newCenter.x + translation.x
                        self.newButtonA.transform = CGAffineTransform(rotationAngle: angleRotate)
                        self.newButtonB.transform = CGAffineTransform(rotationAngle: angleRotate)
                    }
                }
            }else{
                if trainTypeOptionIdx > 0{
                    self.newButtonA.center.x = originalCenter.x + translation.x
                    self.newButtonB.center.x = newCenter.x + translation.x
                    self.newButtonA.transform = CGAffineTransform(rotationAngle: angleRotate)
                    self.newButtonB.transform = CGAffineTransform(rotationAngle: angleRotate)
                }else{
                    if self.newButtonA.center.x < 4 * view.frame.width/5{
                        self.newButtonA.center.x = originalCenter.x + translation.x
                        self.newButtonB.center.x = newCenter.x + translation.x
                        self.newButtonA.transform = CGAffineTransform(rotationAngle: angleRotate)
                        self.newButtonB.transform = CGAffineTransform(rotationAngle: angleRotate)
                    }
                }
            }
        }else if gesture.state == .ended{
            if velocity.x < 0{
                if trainTypeOptionIdx < buttonTitle.count - 1 && self.newButtonA.center.x < view.frame.width/5{
                    UIView.animate(withDuration: 0.5, animations: {
                        self.newButtonA.center.x =  newCenterL.x//self.newCenter.x
                        self.newButtonB.center = originalCenter
                        self.newButtonA.transform = CGAffineTransform(rotationAngle: 2 * 3.14)
                        self.newButtonB.transform = CGAffineTransform(rotationAngle: 2 * 3.14)
                        self.view.layoutIfNeeded()
                    }, completion: { (done) in
                        if done{
                            self.newButtonA = self.newButtonB
                            self.trainTypeOptionIdx += 1
                        }
                        
                    })
                }else{
                    UIView.animate(withDuration: 0.5, animations: {
                        self.newButtonA.center = originalCenter
                        self.newButtonB.center.x = self.newCenter.x
                        self.newButtonA.transform = CGAffineTransform(rotationAngle:0)
                        self.newButtonB.transform = CGAffineTransform(rotationAngle:0)
                        self.view.layoutIfNeeded()
                    })
                }
            }else{
                
                if trainTypeOptionIdx > 0 && self.newButtonA.center.x > 4 * view.frame.width/5{
                    UIView.animate(withDuration: 0.5, animations: {
                        self.newButtonA.center.x =  newCenterR.x
                        self.newButtonB.center = originalCenter
                        self.newButtonA.transform = CGAffineTransform(rotationAngle: -2 * 3.14)
                        self.newButtonB.transform = CGAffineTransform(rotationAngle: -2 * 3.14)
                        self.view.layoutIfNeeded()
                    }, completion: { (bool) in
                        self.newButtonA = self.newButtonB
                        self.trainTypeOptionIdx -= 1
                    })
                }else{
                    UIView.animate(withDuration: 0.5, animations: {
                        self.newButtonA.center = originalCenter
                        self.newButtonB.center.x = self.newCenter.x
                        self.newButtonA.transform = CGAffineTransform(rotationAngle:0)
                        self.newButtonB.transform = CGAffineTransform(rotationAngle:0)
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    @objc func didtaptrainType(){
        print("train type")
    }
    
    func newButton(frame: CGRect) -> UIButton{
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panOnTrainingTypeButton(_:)))
        panRecognizer.delegate = self
        let newButton = UIButton(frame: frame)
        newButton.backgroundColor = UIColor.green
        newButton.layer.cornerRadius = 0.5 * newButton.frame.width
        newButton.layer.borderColor = UIColor.black.cgColor
        newButton.layer.borderWidth = 2
        
        newButton.setTitle("Training Type", for: .normal)
        newButton.setTitleColor(.black, for: .normal)
        newButton.addTarget(self, action: #selector(self.didtaptrainType), for: .touchUpInside)
        
        newButton.addGestureRecognizer(panRecognizer)
        
        
        return newButton
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
        //TODO: Do it with NSCoder
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
        
        self.heartRateLabel.isHidden = true
        
        self.newButtonA = newButton(frame: trainingTypeButton.frame)
        self.newButtonB = newButton(frame: trainingTypeButton.frame)
        self.newButtonA.setTitle(self.buttonTitle[0], for: .normal)
        self.view.addSubview(self.newButtonA)
        self.view.addSubview(self.newButtonB)
        
        self.heartRateLabel.reactive.text <~ Bluetooth.manage.heartRate.signal
        Bluetooth.manage.isAvailable.signal.observeValues { (isAvailable) in
            self.heartRateLabel.isHidden = !isAvailable
            self.heartRateLabel.layoutIfNeeded()
        }
        
    }

}

