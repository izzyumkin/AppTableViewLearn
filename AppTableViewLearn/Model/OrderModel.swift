//
//  OrderModel.swift
//  AppTableViewLearn
//
//  Created by Иван Изюмкин on 24/05/2019.
//  Copyright © 2019 Иван Изюмкин. All rights reserved.
//

import RealmSwift

class Order: Object {
    
    // Товары
    @objc dynamic var coverName = ""
    @objc dynamic var coverCircle: String?
    @objc dynamic var coverRectangle: String?
    
    // Данные для доставки
    @objc dynamic var connection: String?
    @objc dynamic var fullName: String?
    @objc dynamic var deliveryMethod: String?
    @objc dynamic var address: String?
    @objc dynamic var postcode: String?
    
    // Дополнительные данные
    @objc dynamic var comment: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var orderDate = ""
    @objc dynamic var orderNumber = ""
    @objc dynamic var orderPrice = ""
    @objc dynamic var status = ""
    
    convenience init(coverName: String, coverCircle: String?, coverRectangle: String?, connection: String?, fullName: String?, deliveryMethod: String?, address: String?, postcode: String?, comment: String?, imageData: Data?, orderDate: String, orderNumber: String, status: String, orderPrice: String) {
        self.init()
        
        self.coverName = coverName
        self.coverCircle = coverCircle
        self.coverRectangle = coverRectangle
        
        self.connection = connection
        self.fullName = fullName
        self.deliveryMethod = deliveryMethod
        self.address = address
        self.postcode = postcode

        self.comment = comment
        self.imageData = imageData
        self.orderDate = orderDate
        self.orderNumber = orderNumber
        self.orderPrice = orderPrice
        self.status = status
        
    }
    
}
