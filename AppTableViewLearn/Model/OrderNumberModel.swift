//
//  OrderNumberModel.swift
//  AppTableViewLearn
//
//  Created by Иван Изюмкин on 02/08/2019.
//  Copyright © 2019 Иван Изюмкин. All rights reserved.
//

import RealmSwift

class Number: Object {
    
    @objc dynamic var totalNumberOrders = 0
    
    convenience init(totalNumberOrders: Int?) {
        self.init()
        
        self.totalNumberOrders = totalNumberOrders!
        
    }
    
}
