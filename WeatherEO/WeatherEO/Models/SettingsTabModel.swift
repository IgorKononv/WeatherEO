//
//  SettingsTabModel.swift
//  WeatherEO
//
//  Created by Igor Kononov on 31.08.2023.
//

import SwiftUI

enum SettingsModel: Identifiable, CaseIterable {
    case rateApp
    case shareApp

    var id: UUID {
        switch self {
            
        case .rateApp:
            return UUID()
        case .shareApp:
            return UUID()
        }
    }
    var name: String {
        switch self {
            
        case .rateApp:
            return "RATE APP"
        case .shareApp:
            return "SHARE APP"
        }
    }
    
    var image: String {
        switch self {
            
        case .rateApp:
            return "RATE_icon"
        case .shareApp:
            return "SHARE_icon"
        }
    }
}
