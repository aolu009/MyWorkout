//
//  TrainHistoryTableCellViewModel.swift
//  MyWorkout
//
//  Created by Lu Ao on 12/8/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

struct TrainHistoryTableCellViewModel{
    
    private var session: TrainingSession!
    private (set) var sessionID: String!
    
    private var trainName: String{
        get{
            return self.session.trainName.value
        }
    }
    private var date: String{
        get{
            return self.session.date.value
        }
    }
    private var duration: String{
        get{
            return self.session.duration.value
        }
    }
    private var avgHR: String{
        get{
            return self.session.avgHR.value
        }
    }
    private var fatburn: String{
        get{
            return self.session.fatburn.value
        }
    }
    private var hrMax: String{
        get{
            return self.session.hrMax.value
        }
    }
//    private var imgID: String{
//        get{
//            return self.session.imgID.value
//        }
//    }
//    private var videoID: String{
//        get{
//            return self.session.videoID.value
//        }
//    }
    
    init(sessionID: String,session: TrainingSession) {
        self.session = session
        self.sessionID = sessionID
        initVals(sessionID: sessionID)
    }
    
    mutating func initVals(sessionID: String){
        var ses: TrainingSession?
        TrainingSession.getSession(ID: sessionID) { (session)  in
            ses = session
        }
        session = ses!
    }
}

