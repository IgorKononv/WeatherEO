//
//  ListWeatherViewModel.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 01.09.2023.
//

import SwiftUI

class ListWeatherViewModel: ObservableObject {
    @Published var matchingItems: [CitySearchModel] = []
    
    @Published var isFocusedTextField: Bool = false
    @Published var showSettings = false
    @Published var searchText = ""
    
    private var searchCityManager: CitySearchProviding {
        resolve(CitySearchProviding.self)
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
        }
    }
}
