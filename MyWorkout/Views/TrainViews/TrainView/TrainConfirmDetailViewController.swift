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
    var backGroundButton: UIButton!
    var startButton: UIButton!
    var delegate: TrainConfirmDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initController()
    }
}

private extension TrainConfirmDetailViewController{
    func initController(){
        
        view.backgroundColor = .clear
        
        addTouchToDismiss()
        addConfirmDetailTableView()
        addStartButton()
        
    }
    
    func addTouchToDismiss(){
        let frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height/2)
        backGroundButton = UIButton(frame: frame)
        backGroundButton.backgroundColor = .clear
        backGroundButton.addTarget(self, action: #selector(self.dismissOnTouchOutside), for: .touchUpInside)
        view.addSubview(backGroundButton)
    }
    
    func addConfirmDetailTableView(){
        let frame = CGRect(x: 10, y: view.bounds.height/2, width: view.bounds.width - 20, height: 3 * view.bounds.height/10)
        confirmDetailTableView = UITableView(frame: frame)
        confirmDetailTableView.layer.cornerRadius = 0.1 * frame.height
        confirmDetailTableView.delegate = self
        confirmDetailTableView.dataSource = self
        confirmDetailTableView.isScrollEnabled = false
        view.addSubview(confirmDetailTableView)
    }
    
    func addStartButton(){
        let frame = CGRect(x: 10, y: 8 * view.bounds.height/10 + 20, width: view.bounds.width - 20, height: view.bounds.height/10)
        startButton = UIButton(frame: frame)
        startButton.backgroundColor = UIColor.red
        startButton.layer.cornerRadius = 0.1 * startButton.frame.height
        startButton.setTitle(keys.buttonTitle.start, for: .normal)
        startButton.setTitleColor(.blue, for: .normal)
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        view.addSubview(startButton)
    }
    
    @objc func didTapStartButton(){
        self.view.backgroundColor = .clear
        dismiss(animated: true) {
            self.delegate?.didtapStartButton()
        }
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
