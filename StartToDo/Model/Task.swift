//
//  Task.swift
//  StartToDo
//
//  Created by Валентина Лучинович on 27.12.2021.
//

import Foundation
import Firebase
import FirebaseDatabase


struct Task {
    let title: String
    let userID: String
    let ref: DatabaseReference?
    var completed: Bool = false
    
    // Инициализатор для локального создания объекта
    init(title: String, userID: String) {
        self.title = title
        self.userID = userID
        self.ref = nil
    }
    // Иницилиазатор для извлечения объекта из базы данных
    // snapshot -  текущее состояние данных на этот момент (JSON)
    init (snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userID = snapshotValue["userID"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
     }
    
    func convertDictionary() -> Any {
        return ["title": title, "userID": userID, "completed": completed]
    }
}


