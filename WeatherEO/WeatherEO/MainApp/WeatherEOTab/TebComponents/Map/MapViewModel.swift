//
//  MapViewModel.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 31.08.2023.
//

import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    @AppStorage("temperatureScaleModel_ID") var scaleMod: TemperatureScaleModel = .fahrenheit
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 30), span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6))
    @Published var matchingItems: [CitySearchModel] = []
    
    @Published var customAnnotation = [CustomAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: 50, longitude: 30), temp: 0, image: "", isBigInfoCircle: false, fromCases: .currentLocation)]
    
    @Published var temperatureScaleModel: TemperatureScaleModel = .fahrenheit
    @Published var isFocusedTextField: Bool = false
    @Published var searchText = ""
        
    private var weatherManager: WeatherServiceProviding {
        resolve(WeatherServiceProviding.self)
    }
    
    private var searchCityManager: CitySearchProviding {
        resolve(CitySearchProviding.self)
    }
    
    private var mapManager: MapServiceProviding {
        resolve(MapServiceProviding.self)
    }
    
    init() {
        temperatureScaleModel = scaleMod
        mapManager.regionProvider
            .map { $0 }
            .assign(to: &$region)
    }
    
    func tapCancel() {
        withAnimation {
            unDoFocusToTextField()
            searchText = ""
        }
    }
    
    func getCurrentWeather() {
        Task {
            guard let weather = await getWeather(region: CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude), fromCases: .currentLocation) else { return }
            print("getCurrentWeather - \(weather)")
            DispatchQueue.main.async {
                self.customAnnotation.removeAll(where: {$0.fromCases == .currentLocation })
                self.customAnnotation.append(weather)
            }
        }
    }
    
    func getWeatherOnMap(_ city: CitySearchModel) {
        withAnimation {
            self.matchingItems = []
            unDoFocusToTextField()
        }
        
        Task {
            guard let weather = await getWeather(region: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude), fromCases: .mapSearch) else { return }
            
            await MainActor.run {
                print("getWeatherOnMap - \(weather)")
                customAnnotation.removeAll(where: { $0.fromCases == .mapSearch})
                customAnnotation.append(weather)
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: weather.coordinate.latitude, longitude: weather.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6))
            }
        }
    }
        
    private func getWeather(region: CLLocationCoordinate2D, fromCases: FromCases) async -> CustomAnnotationModel? {
        do {
            guard let weather = try await weatherManager.getWeather(latitude: region.latitude, longitude: region.longitude) else { return nil }
            print("weather - \(weather)")
            return CustomAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: weather.coord.lat, longitude: weather.coord.lon), temp: weather.main.temp, image: weather.weather.first?.main ?? "", isBigInfoCircle: false, fromCases: fromCases)
        } catch {
            print("Error fetching weather: \(error)")
            return nil
        }
    }
    
    func checkIfLocationIsEnable() {
        Task {
            do {
                let isGetedRegion = await mapManager.checkIfLocationIsEnable()
                if isGetedRegion {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.getCurrentWeather()
                    }
                }
            }
        }
    }
    
    func changeScale() {
        withAnimation {
            switch temperatureScaleModel {
                
            case .celsius:
                temperatureScaleModel = .fahrenheit
                scaleMod = .fahrenheit
            case .fahrenheit:
                temperatureScaleModel = .celsius
                scaleMod = .celsius
            }
        }
    }
    
    func navigateCurrentPositon() {
        Task {
            do {
                await mapManager.checkIfLocationIsEnable()  
            }
        }
    }
    
    func openMoreMapPointInfo(_ location: CustomAnnotationModel) {
        withAnimation {
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8))
                for index in self.customAnnotation.indices {
                    self.customAnnotation[index].isBigInfoCircle = self.customAnnotation[index].id == location.id
                }
            }
        }
    }
    
    func searchCity()  {
        if !searchText.isEmpty {
            Task {
                do {
                    let matchingItems = await searchCityManager.searchCity(searchText: searchText)
                    DispatchQueue.main.async {
                        withAnimation {
                            self.matchingItems = matchingItems
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.matchingItems = []
            }
        }
    }
    
    func unDoFocusToTextField() {
        isFocusedTextField = false
    }
}
