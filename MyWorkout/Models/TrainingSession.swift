//
//  TrainingSession.swift
//  MyWorkout
//
//  Created by Lu Ao on 12/10/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import FirebaseDatabase
import ReactiveSwift

class TrainingSession: JSONObject{
    /** JSON Object type that identifies Post on Firebase */
    override class var object: FIR.object {
        get {
            return FIR.object.session
        }
    }
    
    private (set) var uid = MutableProperty<String>("")
    private (set) var trainName = MutableProperty<String>("")
    private (set) var date = MutableProperty<String>("")
    private (set) var duration = MutableProperty<String>("")
    private (set) var avgHR = MutableProperty<String>("")
    private (set) var fatburn = MutableProperty<String>("")
    private (set) var hrMax = MutableProperty<String>("")
    private (set) var imgID = MutableProperty<String>("")
    private (set) var videoID = MutableProperty<String>("")
    
    
    
    /** Initializes Post object using FIR snapshot */
    override init(_ snapshot: DataSnapshot,uid: String = UserAccount.userInfo.uid!) {
        super.init(snapshot)
        if let uid = json[keys.uid] as? String {
            self.uid.value = uid
        }
        if let trainName = json[keys.trainName] as? String {
            self.trainName.value = trainName
        }
        if let date = json[keys.date] as? String {
            self.date.value = date
        }
        if let duration = json[keys.duration] as? String {
            self.duration.value = duration
        }
        if let avgHR = json[keys.avgHR] as? String{
            self.avgHR.value = avgHR
        }
        if let fatburn = json[keys.fatburn] as? String {
            self.fatburn.value = fatburn
        }
        if let hrMax = json[keys.hrMax] as? String {
            self.hrMax.value = hrMax
        }
        if let imgID = json[keys.imgID] as? String {
            self.imgID.value = imgID
        }
        if let videoID = json[keys.videoID] as? String{
            self.videoID.value = videoID
        }
    }
    
    /** Gets the Post for a given ID */
    class func getSession(ID: String, completion:@escaping (TrainingSession)->()) {
        super.get(ID, object: object) { (snapshot) in
            // return initialized object
            completion(TrainingSession(snapshot))
        }
    }
    
//    /** Creates a new post */
//    class func create(assetID: String, assetType: FIR.object, hashtag: String) -> String {
//        // Construct json to save
//        let json: [String: AnyObject?] = [keys.uid: FIR.manager.uid as AnyObject,
//                                          keys.timestamp: Date().toString()  as AnyObject,
//                                          keys.assetID: assetID  as AnyObject,
//                                          keys.assetObject: assetType.key()  as AnyObject,
//                                          keys.hashtag: hashtag as AnyObject]
//
//        // Save image
//        let filename = FIR.manager.databasePath(object).childByAutoId().key
//        FIR.manager.databasePath(object).child(filename).setValue(json)
//
//        Like.like(forPostID: "-KdsD5h7pUIMcYXMHTUs")
//        UserPost.addPostToUser(PostID: filename, uID: FIR.manager.uid) { (postRef) in
//            print("Creating new Post object in the database")
//        }
//        Like.createLikeToPost(postID: filename, uID: UserAccount.currentUser.uid!) {
//            print("Creating Like for a post")
//        }
//
//        return filename
//    }
//
    /** Database keys */
    struct keys {
        static let uid = "uid"
        static let trainName = "trainName"
        static let date = "date"
        static let duration = "duration"
        static let avgHR = "avgHR"
        static let fatburn = "fatburn"
        static let hrMax = "hrMax"
        static let imgID = "imgID"
        static let videoID = "videoID"
    }
}
