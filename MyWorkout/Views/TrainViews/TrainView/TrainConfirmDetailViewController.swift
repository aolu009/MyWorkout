//
//  TrainConfirmDetailViewController.swift
//  MyWorkout
//
//  Created by Lu Ao on 12/23/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import UIKit

protocol TrainConfirmDetailViewControllerDelegate {
    func didtapStartButton()
    func didSelectOnTableViewCell()
}

class TrainConfirmDetailViewController: UIViewController {
    
    var confirmDetailTableView: UITableView!
    var delegate: TrainConfirmDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initController()
    }
}

extension TrainConfirmDetailViewController{
    func initController(){
        //addDismissOnTouchOutsidGesture()
        view.backgroundColor = .clear
        let backGroundButton = UIButton(frame: view.bounds)
        backGroundButton.backgroundColor = .clear
        backGroundButton.addTarget(self, action: #selector(self.dismissOnTouchOutside), for: .touchUpInside)
        view.addSubview(backGroundButton)
        
        let tableviewFrame = CGRect(x: 10, y: view.bounds.height/2, width: view.bounds.width - 20, height: 3 * view.bounds.height/10)
        confirmDetailTableView = UITableView(frame: tableviewFrame)
        confirmDetailTableView.layer.cornerRadius = 0.1 * tableviewFrame.height
        view.addSubview(confirmDetailTableView)
        confirmDetailTableView.delegate = self
        confirmDetailTableView.dataSource = self
        confirmDetailTableView.isScrollEnabled = false
        
        let startButton = UIButton(frame: CGRect(x: 10, y: 8 * view.bounds.height/10 + 20, width: view.bounds.width - 20, height: view.bounds.height/10))
        startButton.backgroundColor = UIColor.red
        startButton.layer.cornerRadius = 0.1 * startButton.frame.height
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        view.addSubview(startButton)
        
    }
    
    
}

extension TrainConfirmDetailViewController: UIGestureRecognizerDelegate{
    func addDismissOnTouchOutsidGesture(){
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTouchOutside))
        touchGesture.delegate = self
        view.addGestureRecognizer(touchGesture)
    }
    @objc func dismissOnTouchOutside(){
        UIView.animate(withDuration: 0.01, animations: {
            self.view.backgroundColor = UIColor.clear
            self.view.layoutIfNeeded()
        }) { (done) in
            self.dismiss(animated: true, completion: nil)
        }
    }
}


extension TrainConfirmDetailViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TrainConfirmDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/10
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Target"
        return cell
    }
}
