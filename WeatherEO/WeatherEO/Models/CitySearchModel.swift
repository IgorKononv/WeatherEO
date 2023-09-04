//
//  CitySearchModel.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 03.09.2023.
//

import Foundation

struct CitySearchModel: Decodable {
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let population: Int
    let isCapital: Bool

    enum CodingKeys: String, CodingKey {
        case name
        case latitude
        case longitude
        case country
        case population
        case isCapital = "is_capital"
    }
}
