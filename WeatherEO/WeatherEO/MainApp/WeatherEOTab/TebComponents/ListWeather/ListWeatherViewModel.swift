//
//  ListWeatherViewModel.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 01.09.2023.
//

import SwiftUI

class ListWeatherViewModel: ObservableObject {
    @AppStorage("temperatureScaleModel_ID") var scaleMod: TemperatureScaleModel = .fahrenheit

    @Published var matchingItems: [CitySearchModel] = []
    @Published var weatherModel: [WeatherModel] = []
    @Published var isFocusedTextField: Bool = false
    @Published var showSettings = false
    @Published var searchText = ""
    @Published var showAlert = false
    
    private var searchCityManager: CitySearchProviding {
        resolve(CitySearchProviding.self)
    }
    
    private var realmManager: RealmServiceProviding {
        resolve(RealmServiceProviding.self)
    }
    
    private var weatherManager: WeatherServiceProviding {
        resolve(WeatherServiceProviding.self)
    }
    
    init() {
        getAllCityObjects()
    }
    
    func tapCancel() {
        withAnimation {
            unDoFocusToTextField()
            searchText = ""
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
    
    func openSettings() {
        showSettings = true
    }
    
    func getWeatherOnList(_ city: CitySearchModel) {
        withAnimation {
            self.matchingItems = []
            unDoFocusToTextField()
        }
        let idNewCity = city.name + city.latitude.description + city.longitude.description
        if realmManager.getAllCityObjects().first(where: {$0.id == idNewCity}) == nil {
            realmManager.addNewCityModel(city: CityModel(id: idNewCity, name: city.name, latitude: city.latitude, longitude: city.longitude))
        } else {
            showAlert = true
        }
    }
    
    private func getAllCityObjects() {
        for city in realmManager.getAllCityObjects() {
            Task {
                do {
                    guard let serchedCity = try await weatherManager.getWeather(latitude: city.latitude, longitude: city.longitude) else { return }
                    DispatchQueue.main.async {
                        self.weatherModel.append(serchedCity)
                    }
                }
            }
        }
    }
}
