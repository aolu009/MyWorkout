//
//  TrainingContainerViewController.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/6/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//
// TODO: Modulize and clear the code: Break into containerViewController and custome tabarViewController???
// TODO: Complete the tabBar: https://github.com/codepath/ios_guides/wiki/Creating-a-Custom-Tab-Bar

import UIKit
import ReactiveSwift

class TrainingContainerViewController: UIViewController {

    
    @IBOutlet weak var upperContainerView: UIView!
    @IBOutlet weak var lowerContainerView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    
    @IBOutlet weak var tabBar: UIView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet var tabBarButtons: [UIButton]!
    
    @IBOutlet weak var lowerContainerViewToSeg: NSLayoutConstraint!
    @IBOutlet weak var upperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lowerContainerViewToTop: NSLayoutConstraint!
    @IBOutlet weak var tabBarHeight: NSLayoutConstraint!
    @IBOutlet weak var trainButtonToLeftBorder: NSLayoutConstraint!
    @IBOutlet weak var bodyButtonToTrainButton: NSLayoutConstraint!
    @IBOutlet weak var sleepButtonToBodyButton: NSLayoutConstraint!
    @IBOutlet weak var profileButtonToSleepButton: NSLayoutConstraint!
    
    
    
    
    
    private var prevSelectedButtonTag = 0
    private var lowerViewBounds: CGRect!
    private var originalTopBorder: CGFloat!
    private var originalTabBarHeight: CGFloat!
    private var didtapOnTrainingType = MutableProperty<Bool>(false)
    
    var viewControllers: [UIViewController]!
    
    
    private var lowerViewdidRise = false
    
    
    
    var containerViewController: UIViewController!{
        didSet(oldContentViewController){
            if oldContentViewController != nil{
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            containerViewController.willMove(toParentViewController: self)
            containerViewController.view.frame = self.upperContainerView.bounds
            self.upperContainerView.addSubview(containerViewController.view)
            containerViewController.didMove(toParentViewController: self)
            view.layoutIfNeeded()
        }
    }
    
    
    var lowerContainerViewController: UIViewController!{
        didSet(oldContentViewController){
            if oldContentViewController != nil{
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            let panUpGesture = UIPanGestureRecognizer(target: self, action: #selector(onPanUp))
            panUpGesture.delegate = self
            lowerContainerViewController.willMove(toParentViewController: self)
            lowerContainerViewController.view.frame = self.lowerContainerView.bounds
            self.lowerContainerView.addSubview(lowerContainerViewController.view)
            lowerContainerViewController.didMove(toParentViewController: self)
            lowerContainerView.addGestureRecognizer(panUpGesture)
            view.layoutIfNeeded()
        }
    }
    
    var tabBarViewController: UIViewController!{
        didSet(oldContentViewController){
            if oldContentViewController != nil{
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            tabBarViewController.view.frame = self.tabBarView.bounds
            tabBarViewController.willMove(toParentViewController: self)
            self.tabBarView.addSubview(tabBarViewController.view)
            tabBarViewController.didMove(toParentViewController: self)
            view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        //setupTabBarButtons()
        let spaceBetweenButton = (tabBar.frame.width - 4 * tabBar.frame.height)/5
        trainButtonToLeftBorder.constant = spaceBetweenButton
        bodyButtonToTrainButton.constant = spaceBetweenButton
        sleepButtonToBodyButton.constant = spaceBetweenButton
        profileButtonToSleepButton.constant = spaceBetweenButton
    }
    
    @IBAction func didTabClose(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.lowerContainerViewToSeg.constant = self.originalTopBorder
            self.lowerContainerViewToTop.constant = 0
            self.tabBarHeight.constant = self.originalTabBarHeight
            self.view.layoutIfNeeded()
        }, completion: { (bool) in
            self.closeButton.isHidden = true
            self.segmentController.isHidden = true
            self.upperContainerView.isHidden = false
        })
        tabBarButtons[prevSelectedButtonTag].isSelected = true
        
    }
    
    @IBAction func segmentDidSelect(_ sender: UISegmentedControl) {
        //TODO: Intialize somewhere else so it will only be initialize once
        if sender.selectedSegmentIndex == 1{
            lowerContainerViewController = PersonalBestViewController(nibName: "PersonalBestViewController", bundle: nil)
        }else{
            let vc = TrainHistoryViewController(nibName: "TrainHistoryViewController", bundle: nil) as TrainHistoryViewController
            vc.delegate = self
            lowerContainerViewController = vc
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "TrainingContainerViewController", bundle: nil)
        initController()
    }
    
    override init(nibName: String? , bundle: Bundle?) {
        super.init(nibName: "TrainingContainerViewController", bundle: nil)
        initController()
    }
    
    func initController() {
        let nib = UINib(nibName: "TrainingContainerViewController", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        setupTabBar()
        self.view.backgroundColor = UIColor.black
        self.closeButton.isHidden = true
        self.segmentController.isHidden = true
        self.originalTopBorder = self.lowerContainerViewToSeg.constant
        lowerViewBounds = self.view.frame
        tabBarView.isHidden = true
        
        self.originalTabBarHeight = 0.08 * self.view.frame.height
        self.tabBarHeight.constant = self.originalTabBarHeight
    }
}

//Below are implementations of all method

private extension TrainingContainerViewController{
    func setupTabBar(){
        tabBar.layer.shadowColor = UIColor.blue.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowOffset = CGSize.zero
        tabBarButtons[prevSelectedButtonTag].isSelected = true
    }
    
//    func createTabBarButton(tabBarFrame: CGRect,nTh: CGFloat,numOfButton: CGFloat = 4, title: String = "Test") -> UIButton{
//        let buttonWidth = tabBarFrame.width/numOfButton
//        let frame = CGRect(x: nTh * buttonWidth, y: tabBarFrame.minY, width: buttonWidth, height: tabBarFrame.height)
//        let newButton = UIButton(frame: frame)
//        newButton.addTarget(self, action: #selector(self.didTabOnTabBar), for: .touchUpInside)
//        newButton.backgroundColor = UIColor.blue
//        newButton.setTitle(title, for: .normal)
//        newButton.setTitleColor(.blue, for: .selected)
//        newButton.setTitleColor(.white, for: .normal)
//        newButton.tag = Int(nTh)
//        //newButton.setImage(<#T##image: UIImage?##UIImage?#>, for: .normal)
//        return newButton
//    }
    @IBAction func didTabOnTabBar(tabBarButton: UIButton){
        if tabBarButton.tag != prevSelectedButtonTag{
            tabBarButtons[prevSelectedButtonTag].isSelected = false
            tabBarButtons[tabBarButton.tag].isSelected = true
            prevSelectedButtonTag = tabBarButton.tag
            presentSeletedViewControllers(tag: tabBarButton.tag)
        }
    }
    func presentSeletedViewControllers(tag: Int){
        if tag != 0{
            tabBarView.isHidden = false
            tabBarViewController = viewControllers[tag]
        }else{
            tabBarView.isHidden = true
        }
        
    }
    func didTapStartTraining(){
        //present
        let traingRecordingVC = TrainRecordingViewController()
        present(traingRecordingVC, animated: true) {
            print("TrainingContainerViewController: Presenting TrainingContainerViewController")
        }
    }
}

extension TrainingContainerViewController: UIGestureRecognizerDelegate{
    @objc func onPanUp(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        if gesture.state == .began{
            tabBarButtons[prevSelectedButtonTag].isSelected = false
        }else if gesture.state == .changed{
            if velocity.y < 0 && self.originalTopBorder + translation.y > 10 && self.tabBarHeight.constant != 0{
                self.lowerContainerViewToSeg.constant = self.originalTopBorder + translation.y
                self.lowerContainerViewToTop.constant = translation.y
            }
        }else if gesture.state == .ended{
            if velocity.y <= 0{
                UIView.animate(withDuration: 0.3, animations: {
                    self.lowerContainerViewToSeg.constant = 10
                    self.lowerContainerViewToTop.constant = self.lowerContainerViewToSeg.constant - self.originalTopBorder
                    self.tabBarHeight.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: { (bool) in
                    self.closeButton.isHidden = false
                    self.segmentController.isHidden = false
                    self.upperContainerView.isHidden = true
                })
            }
        }
    }
}

extension TrainingContainerViewController: TrainHistoryViewControllerDelegate{
    func trainHistoryViewShouldEnableScroll() -> Bool {
        return tabBarHeight.constant == 0
    }
}

extension TrainingContainerViewController: TrainViewControllerDelegate{
    func didTapOnButton(button: UIButton) {
        guard let buttonTitle = button.titleLabel?.text else{
                print("Something went wrong after button pressed")
                return
        }
        switch buttonTitle {
        case keys.buttonTitle.start:
            didTapStartTraining()
        case keys.buttonTitle.addNew:
            presentExercisePickerViewController()
        default:
            let confirmDatailViewController = TrainConfirmDetailViewController()
            confirmDatailViewController.modalPresentationStyle = .overFullScreen
            confirmDatailViewController.delegate = self
            present(confirmDatailViewController, animated: true, completion: {
                confirmDatailViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            })
        }
    }
    
    /**
     Add an exercise to queue
     */
    func presentExercisePickerViewController(){
        print("TrainingContainerViewController: AddNew Exercise Button Tapped")
        //        var phototaker: exercisePickerViewController?
        //        exercisePickerViewController = exercisePickerViewController(nibName: "exercisePickerViewController", bundle: nil)
        //        exercisePickerViewController?.view.frame = self.view.bounds
        //        let vc = exercisePickerViewController as? UIViewController
        //        present(vc, animated: true, completion: nil)
    }
    
}
extension TrainingContainerViewController: TrainConfirmDetailViewControllerDelegate{
    func didtapStartButton() {
        print("TrainingContainerViewController: Start Button Tapped")
        didTapStartTraining()
    }
    
    func didSelectOnTableViewCell() {
        print("TrainingContainerViewController: Cell Tapped")
    }
}
