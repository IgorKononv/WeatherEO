//
//  WeatherEOApp.swift
//  WeatherEO
//
//  Created by Igor Kononov on 31.08.2023.
//

import SwiftUI

@main
struct WeatherEOApp: App {
    
    init() {
        registerDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                WeatherEOTab()
                PreView()
            }
        }
    }
    
    private func registerDependencies() {
        register(service: MapServiceProviding.self, creator: MapServiceProvider.init)
        register(service: CitySearchProviding.self, creator: CitySearchProvider.init)
        register(service: RealmServiceProviding.self, creator: RealmServiceProvider.init)
        register(service: WeatherServiceProviding.self, creator: WeatherServiceProvider.init)
    }
}
