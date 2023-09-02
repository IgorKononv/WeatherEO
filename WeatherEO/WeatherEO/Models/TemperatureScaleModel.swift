//
//  TemperatureScaleModel.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 02.09.2023.
//

import Foundation

enum TemperatureScaleModel: String {
    
    case celsius
    case fahrenheit
    
    var image: String {
        switch self {
            
        case .celsius:
            return "celsius_icon"
        case .fahrenheit:
            return "fahrenheit_icon"
        }
        
    }
}
