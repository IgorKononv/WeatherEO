//
//  ContentView.swift
//  WeatherEO
//
//  Created by Igor Kononov on 31.08.2023.
//

import SwiftUI

struct WeatherEOTab: View {
    @StateObject var viewModel = WeatherEOTabViewModel()
    
    var body: some View {
        ZStack {
            Color("main_Color")
            
            VStack {
                Spacer()
                
                TabView(selection: $viewModel.tabWeatherModel) {
                    Text("1")
                        .tag(WeatherEOTabModel.weather)
                    Text("2")
                        .tag(WeatherEOTabModel.map)
                    SettingsTabView()
                        .tag(WeatherEOTabModel.settings)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                WeatherBar(viewModel: viewModel)
                
            }
        }
        .ignoresSafeArea()
    }
}


