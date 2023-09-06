//
//  RealmCityModel.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 01.09.2023.
//

import Foundation
import RealmSwift

class RealmCityModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id = ""
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    
    convenience init(id: String, latitude: Double, longitude: Double) {
        self.init()
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct CityModel: Identifiable {
    let id: String
    let latitude: Double
    let longitude: Double
}
