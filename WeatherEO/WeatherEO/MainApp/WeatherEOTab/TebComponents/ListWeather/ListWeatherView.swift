//
//  ListWeatherView.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 01.09.2023.
//

import SwiftUI

struct ListWeatherView: View {
    @StateObject var viewModel = ListWeatherViewModel()
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    Text(viewModel.weatherModel.isEmpty ? "City not selected" : "Weather")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    ForEach(viewModel.weatherModel, id: \.name) { city in
                        ZStack {
                            Rectangle()
                                .cornerRadius(20)
                                .foregroundColor(.black)
                                .frame(width: ScreenSize.width * 0.85 + 3, height: 103)
                            Rectangle()
                                .cornerRadius(20)
                                .foregroundColor(Color("green_Color"))
                                .frame(width: ScreenSize.width * 0.85, height: 100)
                            HStack {
                                VStack {
                                    Image(city.weather.first?.main ?? "")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 80)
                                    
                                    Text(city.weather.first?.main ?? "")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                Text(city.name)
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                Spacer()
                                VStack {
                                    Text("\(viewModel.scaleMod == .celsius ? Int(city.main.temp - 273.15) : Int((city.main.temp - 273.15) * 9/5 + 32))°")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .padding(.bottom)
                                    HStack {
                                        Text("H:\(viewModel.scaleMod == .celsius ? Int(city.main.temp_max - 273.15) : Int((city.main.temp_max - 273.15) * 9/5 + 32))°")
                                        Text("L:\(viewModel.scaleMod == .celsius ? Int(city.main.temp_min - 273.15) : Int((city.main.temp_min - 273.15) * 9/5 + 32))°")
                                    }
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                            }
                            .padding()
                        }
                        .frame(width: ScreenSize.width * 0.85 + 5)
                    }
                }
                .padding(.vertical, 120)
            }
            
            ListSearchBar(viewModel: viewModel)
        }
        .fullScreenCover(isPresented: $viewModel.showSettings) {
            SettingsView()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text("You have already chosen this city."),
                dismissButton: .default(Text("OK"))
            )
        }
        .ignoresSafeArea()
    }
}

struct ListWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        ListWeatherView()
    }
}
