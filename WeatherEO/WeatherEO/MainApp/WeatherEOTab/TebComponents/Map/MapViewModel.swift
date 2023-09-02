//
//  MapViewModel.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 31.08.2023.
//

import SwiftUI
import MapKit

struct CustomAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let temp: Double
    let mainMap: String
    var isBigInfoCircle: Bool
    
}

class MapViewModel: ObservableObject {
    @AppStorage("temperatureScaleModel_ID") var scaleMod: TemperatureScaleModel = .fahrenheit
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 30), span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6))
    @Published var customAnnotation = [CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 50, longitude: 30), temp: 0, mainMap: "", isBigInfoCircle: false)]
    @Published var weatherModel: WeatherModel?
    @Published var temperatureScaleModel: TemperatureScaleModel = .fahrenheit
    @Published var searchText = ""

    var locationManager: CLLocationManager?
    
    private var weatherManager: WeatherServiceProviding {
        resolve(WeatherServiceProviding.self)
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
        searchText = ""
    }
    
    func tapSerch() {
        
    }
    
    func getWeather() {
        Task {
            do {
                weatherModel = try await weatherManager.getWeather(latitude: region.center.latitude, longitude: region.center.longitude)
                print("weatherModel - \(weatherModel)")
                guard let weatherModel = weatherModel else { return }
                customAnnotation = [
                    CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: weatherModel.coord.lat, longitude: weatherModel.coord.lon), temp: weatherModel.main.temp, mainMap: weatherModel.weather.first?.main ?? "", isBigInfoCircle: false)
                ]
            } catch {
                print(error)
            }
        }
    }
    
    func checkIfLocationIsEnable() {
        Task {
            do {
                await mapManager.checkIfLocationIsEnable()
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
    
    func openMoreMapPointInfo(_ location: CustomAnnotation) {
        withAnimation {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8))
            for index in customAnnotation.indices {
                customAnnotation[index].isBigInfoCircle = customAnnotation[index].id == location.id
            }
        }
    }
}
