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
    
    @Published var customAnnotation: [CustomAnnotationModel] = []
    
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
    
    private var realmManager: RealmServiceProviding {
        resolve(RealmServiceProviding.self)
    }
    
    init() {
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
            DispatchQueue.main.async {
                self.customAnnotation.removeAll(where: {$0.fromCases == .currentLocation })
                self.customAnnotation.append(weather)
            }
        }
    }
    
    func getWeatherOnMap(_ city: CitySearchModel) {
        withAnimation {
            searchText = ""
            matchingItems = []
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
    
    func getWeatherOnRealm() {
        customAnnotation.removeAll(where: { $0.fromCases == .realm})
        let cityFromRealm = realmManager.getAllCityObjects()
        for city in cityFromRealm {
            Task {
                do {
                    guard let serchedCity = try await weatherManager.getWeather(latitude: city.latitude, longitude: city.longitude) else { return }
                                        
                    DispatchQueue.main.async {
                        self.customAnnotation.append(CustomAnnotationModel(coordinate: CLLocationCoordinate2D(latitude: serchedCity.coord.lat, longitude: serchedCity.coord.lon), temp: serchedCity.main.temp, image: serchedCity.weather.first?.main ?? "", isBigInfoCircle: false, fromCases: .realm))
                    }
                }
            }
        }
    }
        
    private func getWeather(region: CLLocationCoordinate2D, fromCases: FromCases) async -> CustomAnnotationModel? {
        do {
            guard let weather = try await weatherManager.getWeather(latitude: region.latitude, longitude: region.longitude) else { return nil }
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
                        self.getWeatherOnRealm()
                    }
                }
            }
        }
    }
    
    func changeScale() {
        withAnimation {
            switch scaleMod {
                
            case .celsius:
                scaleMod = .fahrenheit
            case .fahrenheit:
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
