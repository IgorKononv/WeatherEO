//
//  ListWeatherViewModel.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 01.09.2023.
//

import SwiftUI
import RealmSwift

class ListWeatherViewModel: ObservableObject {
    @AppStorage("temperatureScaleModel_ID") var scaleMod: TemperatureScaleModel = .fahrenheit

    @Published var matchingItems: [CitySearchModel] = []
    @Published var weatherModel: [WeatherModel] = []
    @Published var selectedCity: WeatherModel?
    @Published var isFocusedTextField: Bool = false
    @Published var showSettings = false
    @Published var searchText = ""
    @Published var showAlert = false
    @Published var showDeleteAlert = false

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
            searchText = ""
            matchingItems = []
            unDoFocusToTextField()
        }
        Task {
            do {
                guard let serchedCity = try await weatherManager.getWeather(latitude: city.latitude, longitude: city.longitude) else { return }
                
                let idNewCity = serchedCity.coord.lat.description + serchedCity.coord.lon.description
                
                DispatchQueue.main.async {
                    if self.realmManager.getAllCityObjects().first(where: { $0.id == idNewCity }) == nil {
                        self.weatherModel.append(serchedCity)
                        self.realmManager.addNewCityModel(city: CityModel(id: idNewCity, latitude: serchedCity.coord.lat, longitude: serchedCity.coord.lon))
                    } else {
                        self.showAlert = true
                    }
                }
            }
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
    
    func deleteAlert(_ city: WeatherModel) {
        withAnimation {
            showDeleteAlert = true
            selectedCity = city
        }
    }
    
    func doDeleteCity() {
        guard let selectedCity = selectedCity else { return }
        let idCity = selectedCity.coord.lat.description + selectedCity.coord.lon.description
        
        weatherModel.removeAll(where: {$0.coord.lat == selectedCity.coord.lat && $0.coord.lon == selectedCity.coord.lon})
        realmManager.deleteCityModel(city: CityModel(id: idCity, latitude: selectedCity.coord.lat, longitude: selectedCity.coord.lon))
        cancelDeletingCity()
    }
    
    func cancelDeletingCity() {
        withAnimation {
            showDeleteAlert = false
            selectedCity = nil
        }
    }
}
