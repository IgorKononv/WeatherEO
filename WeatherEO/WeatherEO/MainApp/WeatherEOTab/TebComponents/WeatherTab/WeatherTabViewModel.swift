//
//  WeatherTabViewModel.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 03.09.2023.
//

import SwiftUI
import MapKit

class WeatherTabViewModel: ObservableObject {
    @AppStorage("temperatureScaleModel_ID") var scaleMod: TemperatureScaleModel = .fahrenheit

    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 30), span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6))
    @Published var largeWeatherModel: [LargeWeatherModel] = []

    private var weatherManager: WeatherServiceProviding {
        resolve(WeatherServiceProviding.self)
    }
    
    private var realmManager: RealmServiceProviding {
        resolve(RealmServiceProviding.self)
    }
    
    private var mapManager: MapServiceProviding {
        resolve(MapServiceProviding.self)
    }
    
    init() {
        mapManager.regionProvider
            .map { $0 }
            .assign(to: &$region)
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    func getLargeWeatherData() {
        Task {
            do {
                guard let serchedCity = try await weatherManager.getLargeWeather(latitude: region.center.latitude, longitude: region.center.longitude) else { fetchWeatherForCitiesFromRealm(); return }
                DispatchQueue.main.async {
                    self.largeWeatherModel = []
                    self.largeWeatherModel.append(serchedCity)
                }
                fetchWeatherForCitiesFromRealm()
            }
        }
    }

    func fetchWeatherForCitiesFromRealm() {
        DispatchQueue.main.async {
            let cityFromRealm = self.realmManager.getAllCityObjects()
            for city in cityFromRealm {
                Task {
                    do {
                        guard let serchedCity = try await self.weatherManager.getLargeWeather(latitude: city.latitude, longitude: city.longitude) else { return }
                        self.largeWeatherModel.append(serchedCity)
                    }
                }
            }
        }
    }
    
    func checkIfLocationIsEnable() {
        Task {
            do {
                if await mapManager.checkIfLocationIsEnable() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.getLargeWeatherData()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.largeWeatherModel = []
                    }
                    fetchWeatherForCitiesFromRealm()
                }
            }
        }
    }
    
    func getCurrentWeather(lat: Double, lon: Double) async -> WeatherModel? {
        do {
            let searchedCity = try await self.weatherManager.getWeather(latitude: lat, longitude: lon)
            return searchedCity
        } catch {
            print("Error fetching weather: \(error)")
            return nil
        }
    }
    
    func dateFormat(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let dateObj = dateFormatter.date(from: date) {
            let dayOfWeekFormatter = DateFormatter()
            dayOfWeekFormatter.dateFormat = "E"
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            
            let dayOfWeekString = dayOfWeekFormatter.string(from: dateObj)
            let timeString = timeFormatter.string(from: dateObj)
            
            return "\(dayOfWeekString)\n\(timeString)"
        } else {
            return "error"
        }
    }
}
