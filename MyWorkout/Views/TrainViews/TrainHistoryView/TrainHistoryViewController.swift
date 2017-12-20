//
//  TrainHistoryViewController.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/7/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//
//
import UIKit
import ReactiveSwift

@objc protocol TrainHistoryViewControllerDelegate {
   @objc optional func trainHistoryViewShouldEnableScroll()->Bool
}

class TrainHistoryViewController: UIViewController{

    
    // TODO: Try to initiate a tableview using code
    @IBOutlet weak var trainingDetailTableView: UITableView!
    
    var delegate: TrainHistoryViewControllerDelegate?
    
    //TODO: Try to move the following to viewModel
    private var allhistory = [String]()
    private var sessions = [[TrainingSession]]()//predict size to reloadData?
    private var doneLoading = MutableProperty<Bool>(false)
    private var totalSessionCount = 0
    private var sessionCount = 0
    private var rowheight: CGFloat = 80
    
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
        //Note: To trigger viewDidLoad(), not sure if necessary if viewDidLoad() is never used
        view.isHidden = false
        setupDetailTableView()
        setupDataSource()
        //Wait until all data has been fetched
        doneLoading.signal.observeValues { (done) in
            
            
            if done{
                self.trainingDetailTableView.reloadData()
                self.trainingDetailTableView.rowHeight = 80
                self.trainingDetailTableView.beginUpdates()
                self.trainingDetailTableView.endUpdates()
                
            }
        }
    }
}

extension TrainHistoryViewController{
    func setupDetailTableView(){
        trainingDetailTableView.delegate = self
        trainingDetailTableView.dataSource = self
        trainingDetailTableView.isScrollEnabled = false
        trainingDetailTableView.scrollsToTop = true
        let cell = UINib(nibName: "TrainHistoryTableCell", bundle: nil)
        trainingDetailTableView.register(cell, forCellReuseIdentifier: "TrainHistoryTableCell")
        trainingDetailTableView.estimatedRowHeight = 0
        trainingDetailTableView.separatorStyle = .none
        trainingDetailTableView.backgroundColor = UIColor.black
        //trainingDetailTableView.estimatedSectionHeaderHeight = 0
        //self.trainingDetailTableView.reloadData()
        //trainingDetailTableView.layoutIfNeeded()
        
    }
    //Steup DataSource
    func setupDataSource(){
        //Request months that has training sessions
        AllTrainingHistory.getSessions { (allhistory) in
            self.allhistory = allhistory
            for (hisIdx,history) in self.allhistory.enumerated(){
                //Request array of training IDs using month and uid as key. Note: uid by defaust is Auth.auth().currentUser.uid
                self.sessions.append([TrainingSession]())
                TrainHistory.getSessions(ID: history, completion: { (monthHistory) in
                    self.totalSessionCount += monthHistory.sessionIDs.value.count
                    for id in monthHistory.sessionIDs.value{
                        //Request single session using sessionID
                        TrainingSession.getSession(ID: id, completion: { (session) in
                            self.sessions[hisIdx].append(session)
                            //To guarantee that it has fetched all sessions from server
                            self.sessionCount += 1
                            self.doneLoading.value = self.sessionCount == self.totalSessionCount
                        })
                    }
                })
            }
        }
    }
}

extension TrainHistoryViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        guard sessions.count > 1 else{return 1}
        return allhistory.count
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard sessions.count > 1 else{return 1}
        return sessions[section].count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    //Setup session header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TrainHistoryTableHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.label = section == 0 ? "Last Session" : allhistory[section]
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //If it is still waiting, show the syncing label
        //TODO: Change it to loading animating circle. i.e custom animating view
        guard sessions.count > 1 else{
            let cell = UITableViewCell()
            cell.backgroundColor = .black
            cell.textLabel?.text = "Syncing..."
            cell.textLabel?.textColor = .white
            cell.frame.size.height = 0
            return cell}
        let cell =  tableView.dequeueReusableCell(withIdentifier: "TrainHistoryTableCell", for: indexPath) as! TrainHistoryTableCell
        let session = sessions[indexPath.section][indexPath.row]
        cell.initialize(trainTypeName: session.trainName.value,HRAverage: session.avgHR.value,trainDate: "12/09",trainDuration: session.duration.value)
        cell.frame.size.height = 70
        return cell
    }
}
extension TrainHistoryViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
