//
//  TrainHistoryViewController.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/7/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//
//
import UIKit

class TrainHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {

    
    // TODO: Should be a costume tableview
    @IBOutlet weak var trainingDetailTableView: UITableView!
    var originalFrame: CGRect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
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
        trainingDetailTableView.delegate = self
        trainingDetailTableView.dataSource = self
        trainingDetailTableView.isScrollEnabled = false
        trainingDetailTableView.reloadData()
    }
}
