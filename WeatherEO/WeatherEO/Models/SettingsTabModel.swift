//
//  SettingsTabModel.swift
//  WeatherEO
//
//  Created by Igor Kononov on 31.08.2023.
//

import SwiftUI

enum SettingsModel: Identifiable, CaseIterable {
    case rateApp
    case shareGame

    var id: UUID {
        switch self {
            
        case .rateApp:
            return UUID()
        case .shareGame:
            return UUID()
        }
    }
    var name: String {
        switch self {
            
        case .rateApp:
            return "RATE APP"
        case .shareGame:
            return "SHARE GAME"
        }
    }
    
    var image: String {
        switch self {
            
        case .rateApp:
            return "RATE_icon"
        case .shareGame:
            return "SHARE_icon"
        }
    }
}
