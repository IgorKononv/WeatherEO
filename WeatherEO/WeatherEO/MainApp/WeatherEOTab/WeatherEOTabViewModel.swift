//
//  WeatherEOTabViewModel.swift
//  WeatherEO
//
//  Created by Igor Kononov on 31.08.2023.
//

import SwiftUI

class WeatherEOTabViewModel: ObservableObject {
    @Published var tabWeatherModel: WeatherEOTabModel = .weather
    let tabWeatherModels: [WeatherEOTabModel] = WeatherEOTabModel.allCases
    
    func tapToChangeTab(tab: WeatherEOTabModel) {
        withAnimation {
            tabWeatherModel = tab
        }
    }
}
