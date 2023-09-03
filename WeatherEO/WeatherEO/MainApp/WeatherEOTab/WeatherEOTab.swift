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
                TabView(selection: $viewModel.tabWeatherModel) {
                    Text("1")
                        .tag(WeatherEOTabModel.weather)
                    MapView()
                        .tag(WeatherEOTabModel.map)
                    ListWeatherView()
                        .tag(WeatherEOTabModel.list)
                }
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .never))
                Spacer()
            }
            VStack {
                Spacer()
                WeatherBar(viewModel: viewModel)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.checkIfLocationIsEnable()
        }
    }
}


