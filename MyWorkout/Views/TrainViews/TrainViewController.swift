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
    
    private (set) var trainingTypeButtonLeft: UIButton!
    private (set) var trainingTypeButtonMid: UIButton!
    private (set) var trainingTypeButtonRight: UIButton!
    
    //Train Button related UI Info
    private (set) var trainTypeOptionIdx = 0
    private (set) var newCenter =  CGPoint()
    
    private (set) var trainingTypeButtonLeftCenter =  CGPoint()
    private (set) var trainingTypeButtonMidCenter =  CGPoint()
    private (set) var trainingTypeButtonRightCenter =  CGPoint()
    
    
    //TODO: Replace with viewModel data
    var buttonTitle = ["1","2","3","4"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        // Circlize all button and place them in the right place after base layout is done
        //setupButtons()
        trainingTypeButtonMidCenter = view.center
        trainingTypeButtonLeftCenter = CGPoint(x: -self.view.frame.width/2, y: view.center.y)
        trainingTypeButtonRightCenter = CGPoint(x: 3 * self.view.frame.width/2, y: view.center.y)
        trainingTypeButtonMid.center = trainingTypeButtonMidCenter
        trainingTypeButtonLeft.center = trainingTypeButtonLeftCenter
        trainingTypeButtonRight.center = trainingTypeButtonRightCenter
        
        self.newButtonA.center = self.view.center
        self.newButtonB.center = self.view.center
        self.newButtonB.center.x = self.view.frame.width + self.newButtonB.frame.width/2
        
        
        
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
        
        let newCenterR = CGPoint(x: 3 * self.view.frame.width/2, y: originalCenter.y)
        let newCenterL = CGPoint(x: -self.view.frame.width/2, y: originalCenter.y)
        
        
        let angleRotate: CGFloat! = 4 * 3.14 * (translation.x/self.view.frame.width)
        
        if gesture.state == .began{
            if velocity.x < 0{
                self.newCenter = newCenterR
                if trainTypeOptionIdx < buttonTitle.count - 1{
                    self.newButtonB = newButton(frame: self.trainingTypeButton.frame,action: #selector(self.didtaptrainType),title:buttonTitle[self.trainTypeOptionIdx + 1])
                    self.newButtonB.center = newCenterR
                    self.newButtonB.isHidden = false
                    view.addSubview(self.newButtonB)
                }else{
                    self.newButtonB = newButton(frame: self.trainingTypeButton.frame,action: #selector(self.didtaptrainType),title:buttonTitle[self.trainTypeOptionIdx])
                    self.newButtonB.center = newCenterR
                    self.newButtonB.isHidden = true
                    view.addSubview(self.newButtonB)
                }
                
            }else if velocity.x > 0{
                self.newCenter = newCenterL
                if trainTypeOptionIdx > 0{
                    self.newButtonB = newButton(frame: self.trainingTypeButton.frame,action: #selector(self.didtaptrainType),title:buttonTitle[self.trainTypeOptionIdx - 1])
                    self.newButtonB.center = newCenterL
                    self.newButtonB.isHidden = false
                    view.addSubview(self.newButtonB)
                }else{
                    self.newButtonB = newButton(frame: self.trainingTypeButton.frame,action: #selector(self.didtaptrainType),title:buttonTitle[self.trainTypeOptionIdx])
                    self.newButtonB.center = newCenterL
                    self.newButtonB.isHidden = true
                    view.addSubview(self.newButtonB)
                }
            }
        }else if gesture.state == .changed{
            
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
                        self.newButtonA.center.x =  newCenterL.x
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
    /**
    Setup up costumized rounded button and its desinated action
    */
    func newButton(frame: CGRect,action: Selector,backgroundColor: UIColor = UIColor.green,borderColor: CGColor = UIColor.black.cgColor,borderWidth: CGFloat = 2,backgroundImage: UIImage? = nil,title: String = "Training Type") -> UIButton{
        let newButton = UIButton(frame: frame)
        newButton.addTarget(self, action: action, for: .touchUpInside)
        //Make it a rounded button
        newButton.backgroundColor = backgroundColor
        newButton.layer.cornerRadius = 0.5 * newButton.frame.width
        newButton.layer.borderColor = borderColor
        newButton.layer.borderWidth = borderWidth
        //Set the button Image, will show default title if no image to show.(image == nil)
        if let backgroundImage = backgroundImage{
            newButton.setBackgroundImage(backgroundImage, for: .normal)
        }else{
            newButton.setTitle(title, for: .normal)
            newButton.setTitleColor(.black, for: .normal)
        }
        //TODO: See if it can provide mutiple gestur at once, or make gesture mutable
        //Provide gesture recognizer, if there is any.
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panOnTrainingTypeButton(_:)))
        panGesture.delegate = self
        newButton.addGestureRecognizer(panGesture)
        return newButton
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
    /**
     Initialize elements in the controller
     -It places elements in the view without layingout
     -It also setup all states beneath elements
    */
    func initController() {
        let nib = UINib(nibName: "TrainViewController", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        
        //Setup Button(s)
        newButtonA = newButton(frame: trainingTypeButton.frame,action: #selector(self.didtaptrainType),title:buttonTitle[0])
        newButtonB = newButton(frame: trainingTypeButton.frame,action: #selector(self.didtaptrainType))
        self.view.addSubview(self.newButtonA)
        self.view.addSubview(self.newButtonB)
        trainingTypeButtonMid = newButton(frame: trainingTypeButton.frame,action: #selector(self.didtaptrainType),title:buttonTitle[0])
        trainingTypeButtonLeft = newButton(frame: trainingTypeButton.frame,action: #selector(self.didtaptrainType))
        trainingTypeButtonRight = newButton(frame: trainingTypeButton.frame,action: #selector(self.didtaptrainType))
        self.view.addSubview(trainingTypeButtonMid)
        self.view.addSubview(trainingTypeButtonLeft)
        self.view.addSubview(trainingTypeButtonRight)
        
        self.heartRateLabel.isHidden = true
        
        
        
        //Setup reactive data transfer
        self.heartRateLabel.reactive.text <~ Bluetooth.manage.heartRate.signal
        Bluetooth.manage.isAvailable.signal.observeValues { (isAvailable) in
            self.heartRateLabel.isHidden = !isAvailable
            self.heartRateLabel.layoutIfNeeded()
        }
        
    }

}

