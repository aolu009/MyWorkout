//
//  JSONObject.swift
//  MyWorkout
//
//  Created by Lu Ao on 12/10/17.
//  Copyright © 2017 Lu Ao. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

/**
 Template class for Firebase JSON objects.
 Each JSON object requires:
 - a unique ID (Key)
 - a dictionary that contains object properties retrieved from database
 - an object (type) saved in the dictionary with the key "object" (etc. = "image")
 */
class JSONObject: NSObject {
    /** JSON Object type */
    class var object: FIR.object {
        get {
            assert(false, "Must override this property with FIR.object type")
            return FIR.object.images
        }
    }
    
    // Instance Properties
    /** Unique identifier for the object */
    let ID: String
    /** JSON dictionary that contains object properties */
    let json: [String: AnyObject?]
    
    /** Create object with snapshot */
    init(_ snapshot: DataSnapshot,uid: String = (Auth.auth().currentUser?.uid)!) {
        ID = snapshot.key
        json = snapshot.value as! [String: AnyObject?]
    }
    
    /**
     Helper function to retrieve JSON object from database
     Should be wrapped by subclass with a static FIR.object type
     */
    class func get(_ ID: String, object: FIR.object, completion:@escaping (DataSnapshot)->()) {
        FIR.manager.fetch(objectID: ID, object: object) { (snapshot) in
            if let snapshot = snapshot {
                completion(snapshot)
            } else {
                print("Error: fetch snapshot of FIR \(object.key) ID: \(ID) returned nil")
            }
        }
    }
}
