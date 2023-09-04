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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    Text(viewModel.weatherModel.isEmpty ? "City not selected" : "Weather")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    ForEach(viewModel.weatherModel, id: \.name) { city in
                        ListCityCell(viewModel: viewModel, city: city)
                    }
                }
                .padding(.vertical, 120)
            }
            ListSearchBar(viewModel: viewModel)
            
            DeleteListComponent(viewModel: viewModel)
        }
        .fullScreenCover(isPresented: $viewModel.showSettings) {
            SettingsView()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text("You have already chosen this city."),
                dismissButton: .default(Text("OK"))
            )
        }
        .ignoresSafeArea()
    }
}

struct ListWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        ListWeatherView()
    }
}
