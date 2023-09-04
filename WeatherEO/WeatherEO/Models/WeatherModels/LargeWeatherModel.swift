//
//  LargeWeatherModel.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 04.09.2023.
//

import Foundation

struct LargeWeatherModel: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [WeatherInfo]
    let city: CityInfo
    
    struct WeatherInfo: Decodable {
        let dt: Int
        let main: MainInfo
        let weather: [WeatherDescription]
        let clouds: CloudInfo
        let wind: WindInfo
        let visibility: Int
        let pop: Double
        let sys: SysInfo
        let dt_txt: String
    }
    
    struct MainInfo: Decodable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let sea_level: Int
        let grnd_level: Int
        let humidity: Int
        let temp_kf: Double
    }
    
    struct WeatherDescription: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct CloudInfo: Decodable {
        let all: Int
    }
    
    struct WindInfo: Decodable {
        let speed: Double
        let deg: Int
        let gust: Double
    }
    
    struct SysInfo: Decodable {
        let pod: String
    }
    
    struct CityInfo: Decodable {
        let id: Int
        let name: String
        let coord: Coordinate
        let country: String
        let population: Int
        let timezone: Int
        let sunrise: Int
        let sunset: Int
    }
    
    struct Coordinate: Decodable {
        let lat: Double
        let lon: Double
    }
    
}

    
