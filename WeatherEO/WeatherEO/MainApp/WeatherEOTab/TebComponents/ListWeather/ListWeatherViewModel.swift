//
//  ListWeatherViewModel.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 01.09.2023.
//

import SwiftUI

class ListWeatherViewModel: ObservableObject {
    @Published var showSettings = false
    
    func openSettings() {
        showSettings = true
    }
}
