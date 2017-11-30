//
//  TrainHistoryViewController.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/7/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//
//
import UIKit

@objc protocol TrainHistoryViewControllerDelegate {
   @objc optional func trainHistoryViewShouldEnableScroll()->Bool
}

class TrainHistoryViewController: UIViewController{

    
    // TODO: Should be a costume tableview
    @IBOutlet weak var trainingDetailTableView: UITableView!
    
    //var viewModel = TrainHistroyViewModel()
    //
    var delegate: TrainHistoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        trainingDetailTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
        trainingDetailTableView.isScrollEnabled = (delegate?.trainHistoryViewShouldEnableScroll!())!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: "TrainHistoryViewController", bundle: nil)
        initController()
    }
    
    override init(nibName: String? , bundle: Bundle?) {
        super.init(nibName: "TrainHistoryViewController", bundle: nil)
        initController()
    }
    
    func initController() {
        let nib = UINib(nibName: "TrainHistoryViewController", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        setupDetailTableView()
    }
}

extension TrainHistoryViewController{
    func setupDetailTableView(){
        trainingDetailTableView.delegate = self
        trainingDetailTableView.dataSource = self
        trainingDetailTableView.isScrollEnabled = false
        trainingDetailTableView.scrollsToTop = true
        trainingDetailTableView.estimatedRowHeight = 100
        let cell = UINib(nibName: "TrainHistoryTableCell", bundle: nil)
        trainingDetailTableView.register(cell, forCellReuseIdentifier: "TrainHistoryTableCell")
        trainingDetailTableView.backgroundColor = UIColor.black
        trainingDetailTableView.sectionHeaderHeight = 5
        trainingDetailTableView.layoutIfNeeded()
        trainingDetailTableView.reloadData()
    }
}

extension TrainHistoryViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "TrainHistoryTableCell", for: indexPath) as! TrainHistoryTableCell
        cell.initialize()//with viewModel
        return cell
    }
}
extension TrainHistoryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
