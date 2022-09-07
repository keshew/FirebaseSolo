//
//  User.swift
//  FirebaseSolo
//
//  Created by Артём Коротков on 07.09.2022.
//

import Foundation
import Firebase

struct User {
    var uid: String
    var email: String
    
    init(user: Firebase.User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
