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
    @Persisted var imageName: String
    @Persisted var isPremium: Bool
    @Persisted var isOwnBg: Bool
    
    convenience init(id: String, isPremium: Bool, isOwnBg: Bool, imageName: String) {
        self.init()
        self.id = id
        self.imageName = imageName
        self.isPremium = isPremium
        self.isOwnBg = isOwnBg
    }
}

struct CityModel: Identifiable {
    var id: String
    let imageName: String
    let isPremium: Bool
    var isOwnBg: Bool
}
