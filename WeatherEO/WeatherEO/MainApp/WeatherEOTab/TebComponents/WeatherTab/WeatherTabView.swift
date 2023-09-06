//
//  WeatherTabView.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 03.09.2023.
//

import SwiftUI

struct WeatherTabView: View {
    @StateObject var viewModel = WeatherTabViewModel()
    var body: some View {
        ZStack {
            VStack {
                if viewModel.largeWeatherModel.isEmpty {
                    Text("Not selected weather city")
                } else {
                    TabView {
                        ForEach(viewModel.largeWeatherModel, id: \.city.id) { city in
                            WeatherCityCell(viewModel: viewModel, largeCity: city)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .accentColor(.purple)
                    .frame(height: ScreenSize.height - 160)
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.checkIfLocationIsEnable()
        }
    }
}

struct WeatherTabView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherTabView()
    }
}
