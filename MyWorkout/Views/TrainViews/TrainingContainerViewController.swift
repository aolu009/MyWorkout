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

class TrainingContainerViewController: UIViewController {

    
    @IBOutlet weak var upperContainerView: UIView!
    @IBOutlet weak var lowerContainerView: UIView!
    @IBOutlet weak var tabBar: UIView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var lowerContainerViewToSeg: NSLayoutConstraint!
    @IBOutlet weak var upperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lowerContainerViewToTop: NSLayoutConstraint!
    @IBOutlet weak var tabBarHeight: NSLayoutConstraint!
    
    var originalTopBorder: CGFloat!
    
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
            lowerContainerViewController.willMove(toParentViewController: self)
            lowerContainerViewController.view.frame = self.lowerContainerView.bounds
            self.lowerContainerView.addSubview(lowerContainerViewController.view)
            lowerContainerViewController.didMove(toParentViewController: self)
            view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTabClose(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.lowerContainerViewToSeg.constant = self.originalTopBorder
            self.lowerContainerViewToTop.constant = 0
            self.tabBarHeight.constant = 40
            self.view.layoutIfNeeded()
            self.closeButton.isHidden = true
            self.segmentController.isHidden = true
            
        })
        
        
    }
    
    @IBAction func segmentDidSelect(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1{
            self.lowerContainerViewController = TrainViewController(nibName: "TrainViewController", bundle: nil)
        }else{
            self.lowerContainerViewController = TrainHistoryViewController(nibName: "TrainHistoryViewController", bundle: nil)
        }
    }
    
    
    
    @IBAction func onPanUp(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        if gesture.state == .began{

        }else if gesture.state == .changed{
            if velocity.y < 0 && self.originalTopBorder + translation.y > 10{
                self.lowerContainerViewToSeg.constant = self.originalTopBorder + translation.y
                self.lowerContainerViewToTop.constant = translation.y
            }
        }else if gesture.state == .ended{
            if velocity.y <= 0{
                UIView.animate(withDuration: 0.3, animations: {
                    self.tabBar.frame.size.height = 0
                    self.lowerContainerViewToSeg.constant = 10
                    self.lowerContainerViewToTop.constant = self.lowerContainerViewToSeg.constant - self.originalTopBorder
                    self.tabBarHeight.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: { (bool) in
                    self.closeButton.isHidden = false
                    self.segmentController.isHidden = false
                })
            }
            
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
        self.tabBar.layer.shadowColor = UIColor.blue.cgColor
        self.tabBar.layer.shadowOpacity = 0.5
        self.tabBar.layer.shadowRadius = 2
        self.tabBar.layer.shadowOffset = CGSize.zero
        self.closeButton.isHidden = true
        self.segmentController.isHidden = true
        self.originalTopBorder = self.lowerContainerViewToSeg.constant
        self.tabBar.layoutIfNeeded()
        
    }

}
