//
//  TrainingContainerViewController.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/5/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//
//TODO: Private: Same file and from same class or declaration; fileprivate: Just same file
//TODO: Find out the proper way to rotate the buttons

import UIKit
import ReactiveSwift
import ReactiveCocoa

class TrainViewController: UIViewController {

    @IBOutlet weak var trainNameLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var trainingTypeButton: UIButton!
    @IBOutlet weak var addTrainingButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startButtonToBottom: NSLayoutConstraint!
    
    /**
     Left,Middle,Right Button
     So there will always three button when paning right or left
    */
    private var trainingTypeButtonLeft: UIButton!
    private var trainingTypeButtonMid: UIButton!
    private var trainingTypeButtonRight: UIButton!
    
    //Train Button related UI Info
    private var trainTypeOptionIdx = 0
    private var trainingTypeButtonLeftCenter =  CGPoint()
    private var trainingTypeButtonMidCenter =  CGPoint()
    private var trainingTypeButtonRightCenter =  CGPoint()
    
    
    //TODO: Replace with viewModel data. Data Size must be greater 3
    private var buttonTitle = ["1","2","3","4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        // Circlize all button and place them in the right place after base layout is done
        setupButtons()
        
    }
    
    @IBAction func didTapAddExercise(_ sender: Any) {
        // Present exercisePickerViewController
        presentExercisePickerViewController()
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
        
        placeButtons()
        heartRateLabel.isHidden = true
        //Setup reactive data transfer
        self.heartRateLabel.reactive.text <~ Bluetooth.manage.heartRate.signal
        Bluetooth.manage.isAvailable.signal.observeValues { (isAvailable) in
            self.heartRateLabel.isHidden = !isAvailable
            self.heartRateLabel.layoutIfNeeded()
        }
        
    }

}

/**
 Below are implementation of button movement when pan, and other setup methods
 */
private extension TrainViewController{
    
    func setupButtons(){
        //Setup Training Type Button
        trainingTypeButtonMidCenter = view.center
        trainingTypeButtonLeftCenter = CGPoint(x: -self.view.frame.width/2, y: view.center.y)
        trainingTypeButtonRightCenter = CGPoint(x: 3 * self.view.frame.width/2, y: view.center.y)
        trainingTypeButtonMid.center = trainingTypeButtonMidCenter
        trainingTypeButtonLeft.center = trainingTypeButtonLeftCenter
        trainingTypeButtonRight.center = trainingTypeButtonRightCenter
        //Setup addTrainingButton
        addTrainingButton.layer.cornerRadius = 0.5 * addTrainingButton.frame.width
        addTrainingButton.layer.borderColor = UIColor.blue.cgColor
        addTrainingButton.layer.borderWidth = 2
        addTrainingButton.backgroundColor = UIColor.red
        //Setup heartRateLabel
        heartRateLabel.layer.cornerRadius = 0.5 * heartRateLabel.frame.width
        heartRateLabel.layer.borderColor = UIColor.blue.cgColor
        heartRateLabel.layer.borderWidth = 2
        heartRateLabel.layer.backgroundColor = UIColor.red.cgColor
        //heartRateLabel.backgroundColor = UIColor.red
        
        startButton.backgroundColor = UIColor.red
        startButton.layer.cornerRadius = 0.1 * startButton.frame.height
        
        trainNameLabel.textColor = UIColor.white
        
        self.view.backgroundColor = UIColor.black
        startButtonToBottom.constant = startButton.frame.height/3
    }
    
    func placeButtons(){
        //Setup Button(s)
        trainingTypeButtonMid = newButton(frame: trainingTypeButton.frame,action: #selector(self.didtaptrainType),title:buttonTitle[0])
        trainingTypeButtonLeft = newButton(frame: trainingTypeButton.frame,action: #selector(self.didtaptrainType))
        trainingTypeButtonRight = newButton(frame: trainingTypeButton.frame,action: #selector(self.didtaptrainType))
        self.view.addSubview(trainingTypeButtonMid)
        self.view.addSubview(trainingTypeButtonLeft)
        self.view.addSubview(trainingTypeButtonRight)
    }
    
    @objc func didtaptrainType(){
        print("train type")
    }
    
    func presentExercisePickerViewController(){
        //        var phototaker: exercisePickerViewController?
        //        exercisePickerViewController = exercisePickerViewController(nibName: "exercisePickerViewController", bundle: nil)
        //        exercisePickerViewController?.view.frame = self.view.bounds
        //        let vc = exercisePickerViewController as? UIViewController
        //        present(vc, animated: true, completion: nil)
    }
}
extension TrainViewController: UIGestureRecognizerDelegate{
    /**
     Setup up costumized rounded button and its desinated action
     */
    func newButton(frame: CGRect,action: Selector,backgroundColor: UIColor = UIColor.green,borderColor: CGColor = UIColor.blue.cgColor,borderWidth: CGFloat = 2,backgroundImage: UIImage? = nil,title: String = "Training Type") -> UIButton{
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
    /**
     How Button move when panning on it
    */
    @objc func panOnTrainingTypeButton(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        let angleRotate: CGFloat! = 4 * 3.14 * (translation.x/self.view.frame.width)
        let dataIdxRight = trainTypeOptionIdx == buttonTitle.count - 1 ? trainTypeOptionIdx : trainTypeOptionIdx + 1
        let dataIdxLeft = trainTypeOptionIdx == 0 ? trainTypeOptionIdx : trainTypeOptionIdx - 1
        
        if gesture.state == .began{
            trainingTypeButtonRight = newButton(frame: self.trainingTypeButton.frame,action: #selector(self.didtaptrainType),title:buttonTitle[dataIdxRight])
            trainingTypeButtonLeft = newButton(frame: self.trainingTypeButton.frame,action: #selector(self.didtaptrainType),title:buttonTitle[dataIdxLeft])
            trainingTypeButtonLeft.isHidden = dataIdxLeft == trainTypeOptionIdx
            trainingTypeButtonRight.isHidden = dataIdxRight == trainTypeOptionIdx
            view.addSubview(trainingTypeButtonRight)
            view.addSubview(trainingTypeButtonLeft)
        }else if gesture.state == .changed{
            if dataIdxLeft == trainTypeOptionIdx && velocity.x > 0{//On panning right
                if trainingTypeButtonMid.center.x > view.frame.width/5{
                    trainingTypeButtonMid.center.x = trainingTypeButtonMidCenter.x + translation.x
                    trainingTypeButtonRight.center.x = trainingTypeButtonRightCenter.x + translation.x
                    trainingTypeButtonLeft.center.x = trainingTypeButtonLeftCenter.x + translation.x
                    trainingTypeButtonMid.transform = CGAffineTransform(rotationAngle: angleRotate)
                    trainingTypeButtonRight.transform = CGAffineTransform(rotationAngle: angleRotate)
                    trainingTypeButtonLeft.transform = CGAffineTransform(rotationAngle: angleRotate)
                }
            }else if dataIdxRight == trainTypeOptionIdx && velocity.x < 0{//On panning right
                if trainingTypeButtonMid.center.x < 4 * view.frame.width/5{
                    trainingTypeButtonMid.center.x = trainingTypeButtonMidCenter.x + translation.x
                    trainingTypeButtonRight.center.x = trainingTypeButtonRightCenter.x + translation.x
                    trainingTypeButtonLeft.center.x = trainingTypeButtonLeftCenter.x + translation.x
                    trainingTypeButtonMid.transform = CGAffineTransform(rotationAngle: angleRotate)
                    trainingTypeButtonRight.transform = CGAffineTransform(rotationAngle: angleRotate)
                    trainingTypeButtonLeft.transform = CGAffineTransform(rotationAngle: angleRotate)
                }
            }else{
                trainingTypeButtonMid.center.x = trainingTypeButtonMidCenter.x + translation.x
                trainingTypeButtonRight.center.x = trainingTypeButtonRightCenter.x + translation.x
                trainingTypeButtonLeft.center.x = trainingTypeButtonLeftCenter.x + translation.x
                trainingTypeButtonMid.transform = CGAffineTransform(rotationAngle: angleRotate)
                trainingTypeButtonRight.transform = CGAffineTransform(rotationAngle: angleRotate)
                trainingTypeButtonLeft.transform = CGAffineTransform(rotationAngle: angleRotate)
            }
        }else if gesture.state == .ended{
            if velocity.x > 0 && trainingTypeButtonMid.center.x > 4 * view.frame.width/7{//Ending in paning to the right
                if dataIdxLeft == trainTypeOptionIdx{//When there is no data on the left to show
                    //Move back to original
                    UIView.animate(withDuration: 0.5, animations: {
                        self.trainingTypeButtonMid.center = self.trainingTypeButtonMidCenter
                        self.trainingTypeButtonRight.center = self.trainingTypeButtonRightCenter
                        self.trainingTypeButtonLeft.center = self.trainingTypeButtonLeftCenter
                        self.trainingTypeButtonMid.transform = CGAffineTransform(rotationAngle: 0)
                        self.trainingTypeButtonRight.transform = CGAffineTransform(rotationAngle: 0)
                        self.trainingTypeButtonLeft.transform = CGAffineTransform(rotationAngle: 0)
                        self.view.layoutIfNeeded()
                    })
                }else{
                    UIView.animate(withDuration: 0.5, animations: {
                        self.trainingTypeButtonMid.center = self.trainingTypeButtonRightCenter
                        self.trainingTypeButtonRight.center = self.trainingTypeButtonRightCenter
                        self.trainingTypeButtonLeft.center = self.trainingTypeButtonMidCenter
                        self.trainingTypeButtonMid.transform = CGAffineTransform(rotationAngle: 2 * 3.14)
                        self.trainingTypeButtonRight.transform = CGAffineTransform(rotationAngle: 2 * 3.14)
                        self.trainingTypeButtonLeft.transform = CGAffineTransform(rotationAngle: 2 * 3.14)
                        self.view.layoutIfNeeded()
                    }, completion: { (done) in
                        self.trainingTypeButtonMid = self.trainingTypeButtonLeft
                        self.trainTypeOptionIdx -= 1
                        //self.trainNameLabel.text = "Training Type \(self.trainTypeOptionIdx)"
                    })
                }
            }else if velocity.x < 0 && trainingTypeButtonMid.center.x < 3 * view.frame.width/7{//Ending in paning to the left
                if dataIdxRight == trainTypeOptionIdx{//When there is no data on the right to show
                    //Move back to original
                    UIView.animate(withDuration: 0.5, animations: {
                        self.trainingTypeButtonMid.center = self.trainingTypeButtonMidCenter
                        self.trainingTypeButtonRight.center = self.trainingTypeButtonRightCenter
                        self.trainingTypeButtonLeft.center = self.trainingTypeButtonLeftCenter
                        self.trainingTypeButtonMid.transform = CGAffineTransform(rotationAngle: 0)
                        self.trainingTypeButtonRight.transform = CGAffineTransform(rotationAngle: 0)
                        self.trainingTypeButtonLeft.transform = CGAffineTransform(rotationAngle: 0)
                        self.view.layoutIfNeeded()
                    })
                }else{
                    UIView.animate(withDuration: 0.5, animations: {
                        self.trainingTypeButtonMid.center = self.trainingTypeButtonLeftCenter
                        self.trainingTypeButtonRight.center = self.trainingTypeButtonMidCenter
                        self.trainingTypeButtonLeft.center = self.trainingTypeButtonLeftCenter
                        self.trainingTypeButtonMid.transform = CGAffineTransform(rotationAngle: -2 * 3.14)
                        self.trainingTypeButtonRight.transform = CGAffineTransform(rotationAngle: -2 * 3.14)
                        self.trainingTypeButtonLeft.transform = CGAffineTransform(rotationAngle: -2 * 3.14)
                        self.view.layoutIfNeeded()
                    }, completion: { (done) in
                        self.trainingTypeButtonMid = self.trainingTypeButtonRight
                        self.trainTypeOptionIdx += 1
                    })
                }
            }else{//if ended with velocity.x == 0
                //Move back to original
                UIView.animate(withDuration: 0.5, animations: {
                    self.trainingTypeButtonMid.center = self.trainingTypeButtonMidCenter
                    self.trainingTypeButtonRight.center = self.trainingTypeButtonRightCenter
                    self.trainingTypeButtonLeft.center = self.trainingTypeButtonLeftCenter
                    self.trainingTypeButtonMid.transform = CGAffineTransform(rotationAngle: 0)
                    self.trainingTypeButtonRight.transform = CGAffineTransform(rotationAngle: 0)
                    self.trainingTypeButtonLeft.transform = CGAffineTransform(rotationAngle: 0)
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
}
