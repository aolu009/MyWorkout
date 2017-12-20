//
//  AllTrainingHistory.swift
//  MyWorkout
//
//  Created by Lu Ao on 12/18/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import FirebaseDatabase
import ReactiveSwift

class AllTrainingHistory: JSONObject{
    /** JSON Object type that identifies Post on Firebase */
    override class var object: FIR.object {
        get {
            return FIR.object.allSessions
        }
    }
    
    private (set) var uid = MutableProperty<String>("")
    private (set) var sessions = MutableProperty<[String]>([])
    
    
    
    
    /** Initializes Post object using FIR snapshot */
    override init(_ snapshot: DataSnapshot,uid: String) {
        super.init(snapshot)
        //        if let uid = json[keys.uid] as? String {
        //            self.uid.value = uid
        //        }
//        if let sessionids = json[uid] as? [String] {
//            //print("FIR: \(sessionids)")
//            //self.sessionIDs.value = sessionids
//        }
        self.sessions.value = (snapshot.value as? [String])!
        
    }
    
    /** Gets the Post for a given ID */
    class func getSessions(ID: String = UserAccount.userInfo.uid!, completion:@escaping ([String])->()) {
        super.get(ID, object: object) { (snapshot) in
            // return initialized object
            completion(snapshot.value as! [String])
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
        static let sessionIDs = "sessionIDs"
    }
}
