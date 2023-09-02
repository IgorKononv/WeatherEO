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
    
    private var mapManager: MapServiceProviding {
        resolve(MapServiceProviding.self)
    }
    
    func tapToChangeTab(tab: WeatherEOTabModel) {
        withAnimation {
            tabWeatherModel = tab
        }
    }
    
    func checkIfLocationIsEnable() {
        Task {
            do {
                await mapManager.checkIfLocationIsEnable()
            }
        }
    }
}
