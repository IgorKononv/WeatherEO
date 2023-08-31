//
//  SettingsTabViewModel.swift
//  WeatherEO
//
//  Created by Igor Kononov on 31.08.2023.
//

import SwiftUI
import StoreKit

class SettingsTabViewModel: ObservableObject {
    @Environment(\.requestReview) var requestReview
    @Published var arraySettingsModel: [SettingsModel] = SettingsModel.allCases
    @Published var isShareSheetPresented = false
    @Published var shareText = ""
    
    
    func clickButton(_ cell: SettingsModel) {
        switch cell {
        case .rateApp:
            break
        case .shareGame:
            tapShareButton()
        }
    }
    
    private func tapShareButton() {
        shareText = "Download RouletteApp now on AppStore: https://apps.apple.com/us/app/RouletteApp"
        isShareSheetPresented = true
    }
}
