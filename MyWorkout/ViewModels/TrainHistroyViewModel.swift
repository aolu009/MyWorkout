//
//  TrainHistroyViewModel.swift
//  MyWorkout
//
//  Created by Lu Ao on 11/13/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import ReactiveSwift

struct TrainHistoryViewModel{
    
//    private var allhistory = [String]()
//    private var sessions = [[TrainingSession]]()
//    private var doneLoading = MutableProperty<Bool>(false)
//    
//    
//    
//    
//    
//    mutating func initVals(){
//        var totalSessionCount = 0
//        var sessionCount = 0
//        var doneLoading = MutableProperty<Bool>(false)
//        var sessions = [[TrainingSession]]()
//        var headers = [String]()
//        self.doneLoading <~ doneLoading
//        AllTrainingHistory.getSessions { (allhistory) in
//            headers = allhistory
//            for (hisIdx,history) in headers.enumerated(){
//                //Request array of training IDs using month and uid as key. Note: uid by defaust is Auth.auth().currentUser.uid
//                sessions.append([TrainingSession]())
//                TrainHistory.getSessions(ID: history, completion: { (monthHistory) in
//                    totalSessionCount += monthHistory.sessionIDs.value.count
//                    for id in monthHistory.sessionIDs.value{
//                        //Request single session using sessionID
//                        TrainingSession.getSession(ID: id, completion: { (session) in
//                            sessions[hisIdx].append(session)
//                            //To guarantee that it has fetched all sessions from server
//                            sessionCount += 1
//                            doneLoading.value = sessionCount == totalSessionCount
//                        })
//                    }
//                })
//            }
//        }
//        doneLoading.signal.observeValues { (done) in
//            if done{
//                self.allhistory = allhistory
//            }
//        }
//    }
}
