//
//  PlaceModel.swift
//  AppTableViewLearn
//
//  Created by Иван Изюмкин on 24/05/2019.
//  Copyright © 2019 Иван Изюмкин. All rights reserved.
//

import UIKit

struct Place {
    
    var name: String
    var location: String?
    var type: String?
    var image: UIImage?
    var refactorImage: String?
    
    static let establishments = ["Бургерная Burger Heroes", "«Юность» в «ЭМА»", "Ресторан «Клёво»", "The Hummus", "Кафе «Любовь Пирогова»", "Кафе «Дагестанская лавка»", "Ресторан La Pasta", "Кафе Mary & Dogs", "Кафе «Кусаки»", "Ресторан «Северяне»", "Ресторан «Латинский квартал»"]
    
    static func getPlaces() -> [Place] {
        
        var places = [Place]()
        
        for place in establishments {
            places.append(Place(name: place, location: "Ноябрьск", type: "Ресторан", image: nil, refactorImage: place))
        }
        
        return places
        
    }
    
}
