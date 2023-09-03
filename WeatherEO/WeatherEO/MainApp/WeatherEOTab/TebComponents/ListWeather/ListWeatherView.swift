//
//  ListWeatherView.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 01.09.2023.
//

import SwiftUI

struct ListWeatherView: View {
    @StateObject var viewModel = ListWeatherViewModel()
    var body: some View {
        ZStack {
            ListSearchBar(viewModel: viewModel)
            
        }
        .fullScreenCover(isPresented: $viewModel.showSettings) {
            SettingsView()
        }
        .ignoresSafeArea()
    }
}

struct ListWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        ListWeatherView()
    }
}
