//
//  WeatherCityCell.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 04.09.2023.
//

import SwiftUI

struct WeatherCityCell: View {
    @ObservedObject var viewModel: WeatherTabViewModel
    let largeCity: LargeWeatherModel
    @State var city: WeatherModel?
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    if let temp = city {
                        Image(temp.weather.first?.main ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 64)
                            .padding(.top, 10)
                            .padding(.bottom, -10)

                        Text(temp.name)
                            .font(.system(size: 30, weight: .semibold))
                            .frame(height: 80)

                        Text("\(viewModel.scaleMod == .celsius ? Int(temp.main.temp - 273.15) : Int((temp.main.temp - 273.15) * 9/5 + 32))°")
                            .font(.system(size: 90, weight: .regular))
                            .offset(x: 15)
                            .padding(.top, -20)
                        Text(temp.weather.first?.main ?? "")
                            .font(.system(size: 22, weight: .semibold))
                        HStack {
                            Text("H:\(viewModel.scaleMod == .celsius ? Int(temp.main.temp_max - 273.15) : Int((temp.main.temp_max - 273.15) * 9/5 + 32))°")
                            Text("L:\(viewModel.scaleMod == .celsius ? Int(temp.main.temp_min - 273.15) : Int((temp.main.temp_min - 273.15) * 9/5 + 32))°")
                        }
                        .font(.system(size: 22, weight: .semibold))
                    }
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color("green_Color"))
                            .frame(width: ScreenSize.width * 0.9)
                            .cornerRadius(20)

                        VStack {
                            Text("Weather five days forecast")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(largeCity.list, id: \.dt) { list in
                                        VStack(spacing: 4) {
                                            Text(viewModel.dateFormat(list.dt_txt))
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.white)
                                                .padding(.bottom)
                                            
                                            ForEach(list.weather, id: \.id) { weather in
                                                Image(weather.main)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 30)
                                            }
                                            Text("\(viewModel.scaleMod == .celsius ? Int(list.main.temp - 273.15) : Int((list.main.temp - 273.15) * 9/5 + 32))°")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.white)
                                            .padding()
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            if let temp = city {
                                VStack(spacing: 25) {
                                    HStack(spacing: 25) {
                                        VStack {
                                            Text("Wind speed")
                                            
                                            Image("speed_icon")
                                            
                                            Text("\(temp.wind.speed.description) m/s")
                                        }
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        
                                        VStack {
                                            Text("Wind degree")
                                            
                                            Image(systemName: "arrow.right.circle.fill")
                                                .rotationEffect(.degrees(temp.wind.deg - 90))
                                                .font(.system(size: 72))
                                            
                                            Text(temp.wind.deg.description)
                                            
                                        }
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    }
                                    HStack(spacing: 25) {
                                        VStack {
                                            Text("Humidity")
                                            
                                            Image("humidity_icon")
                                            
                                            Text("\(temp.main.humidity.description)%")
                                        }
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        
                                        VStack {
                                            Text("Pressure")
                                            
                                            Image("pressure_icon")
                                            
                                            Text(temp.main.pressure.description)
                                        }
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    }
                                    VStack {
                                        Text("Feels like")
                                        
                                        Image("feels_like_icon")
                                        
                                        Text("\(viewModel.scaleMod == .celsius ? Int(temp.main.feels_like - 273.15) : Int((temp.main.feels_like - 273.15) * 9/5 + 32))°")
                                    }
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                }
                                .padding()
                            }
                            Spacer()
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 5)
                    }
                    .padding(.top, 20)
                    .frame(width: ScreenSize.width * 0.9)
                }
                .padding(.bottom, 70)
                .frame(width: ScreenSize.width)
            }
        }
        .onAppear {
            Task {
                city = await viewModel.getCurrentWeather(lat: largeCity.city.coord.lat, lon: largeCity.city.coord.lon)
            }
        }
    }
}

