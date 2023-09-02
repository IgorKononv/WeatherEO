//
//  WeatherServiceProvider.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 01.09.2023.
//

import Foundation

protocol WeatherServiceProviding {
    func getWeather(latitude: Double, longitude: Double) async throws -> WeatherModel?
}

class WeatherServiceProvider: WeatherServiceProviding {
    let appKey = "eb553d563cb348004ea8d791c12e96ae"
    
    func getWeather(latitude: Double, longitude: Double) async throws -> WeatherModel? {

        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(appKey)"
        guard let url = URL(string: urlString) else { return nil }
        
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            print("aaa- \(data)")
            let weatherData = try JSONDecoder().decode(WeatherModel.self, from: data)
            
            return weatherData
        } catch {
            throw error
        }
    }
}
