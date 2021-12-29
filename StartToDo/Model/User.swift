//
//  User.swift
//  StartToDo
//
//  Created by Валентина Лучинович on 27.12.2021.
//

import Foundation
import Firebase

struct Person {
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email ?? ""
    }
}
