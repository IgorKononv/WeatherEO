//
//  WeatherEOTabModel.swift
//  WeatherEO
//
//  Created by Igor Kononov on 31.08.2023.
//

import Foundation

enum WeatherEOTabModel: CaseIterable {
    case weather
    case map
    case list
    
    var title: String {
        switch self {
            
        case .weather:
            return "Weather"
        case .map:
            return "Map"
        case .list:
            return "List"
        }
    }
    
    var image: String {
        switch self {
            
        case .weather:
            return "weather_icon"
        case .map:
            return "map_icon"
        case .list:
            return "list_icon"
        }
    }
}
