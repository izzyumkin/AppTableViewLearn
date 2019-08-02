//
//  StorageMeneger.swift
//  AppTableViewLearn
//
//  Created by Иван Изюмкин on 25/05/2019.
//  Copyright © 2019 Иван Изюмкин. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageMeneger {
    
    
    static func saveObject(_ place: Order) {
        
        try! realm.write {
            realm.add(place)
        }
        
    }
    
    static func deleteObject(_ place: Order) {
        
        try! realm.write {
            realm.delete(place)
        }
        
    }
    
}
