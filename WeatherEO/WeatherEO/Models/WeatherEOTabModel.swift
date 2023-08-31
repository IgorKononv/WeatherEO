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
    case settings
    
    var title: String {
        switch self {
            
        case .weather:
            return "Weather"
        case .map:
            return "Map"
        case .settings:
            return "settings"
        }
    }
    
    var image: String {
        switch self {
            
        case .weather:
            return "weather_icon"
        case .map:
            return "map_icon"
        case .settings:
            return "settings_icon"
        }
    }
}
