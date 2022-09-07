//
//  Task.swift
//  FirebaseSolo
//
//  Created by Артём Коротков on 07.09.2022.
//

import Foundation
import Firebase

struct Task {
    var title: String
    var userID: String
    var isCompleted: Bool = false
    let ref: Firebase.DatabaseReference?
    
    init(title: String, userID: String) {
        self.title = title
        self.userID = userID
        self.ref = nil
    }
    
    init(snapshot: Firebase.DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userID = snapshotValue["userID"] as! String
        isCompleted = snapshotValue["isCompleted"] as! Bool
        ref = snapshot.ref
    }
}
