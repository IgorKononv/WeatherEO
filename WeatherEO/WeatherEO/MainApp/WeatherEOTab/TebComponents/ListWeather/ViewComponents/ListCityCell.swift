//
//  ListCityCell.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 04.09.2023.
//

import SwiftUI

struct ListCityCell: View {
    @ObservedObject var viewModel: ListWeatherViewModel
    let city: WeatherModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(20)
                .foregroundColor(.black)
                .frame(width: ScreenSize.width * 0.85 + 3, height: 118)
            Rectangle()
                .cornerRadius(20)
                .foregroundColor(Color("green_Color"))
                .frame(width: ScreenSize.width * 0.85, height: 115)
            HStack {
                VStack {
                    Image(city.weather.first?.main ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                    
                    Text(city.weather.first?.main ?? "")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
                Spacer()
                Text(city.name)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                VStack {
                    Text("\(viewModel.scaleMod == .celsius ? Int(city.main.temp - 273.15) : Int((city.main.temp - 273.15) * 9/5 + 32))°")
                        .font(.system(size: 40, weight: .semibold))
                        .frame(height: 80)
                    HStack {
                        Text("H:\(viewModel.scaleMod == .celsius ? Int(city.main.temp_max - 273.15) : Int((city.main.temp_max - 273.15) * 9/5 + 32))°")
                        Text("L:\(viewModel.scaleMod == .celsius ? Int(city.main.temp_min - 273.15) : Int((city.main.temp_min - 273.15) * 9/5 + 32))°")
                    }
                    .font(.system(size: 15, weight: .semibold))
                }
                .foregroundColor(.white)
            }
            .padding()
        }
        .frame(width: ScreenSize.width * 0.85 + 5)
        .onTapGesture {
            viewModel.deleteAlert(city)
        }
    }
}
