//
//  WeatherBar.swift
//  WeatherEO
//
//  Created by Igor Kononov on 31.08.2023.
//

import SwiftUI

struct WeatherBar: View {
    @ObservedObject var viewModel = WeatherEOTabViewModel()

    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                Rectangle()
                    .frame(height: 115)
                    .foregroundColor(Color("green_Color"))
                    .cornerRadius(20)
                
                Rectangle()
                    .frame(height: 110)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            
            HStack {
                ForEach(viewModel.tabWeatherModels, id: \.title) { tab in
                    Button {
                        viewModel.tapToChangeTab(tab: tab)
                    } label: {
                        Spacer()
                        VStack {
                            Image(tab.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: viewModel.tabWeatherModel == tab ? 50 : 40)
                            
                            Text(tab.title)
                                .foregroundColor(viewModel.tabWeatherModel == tab ? .black : .gray)
                                .font(viewModel.tabWeatherModel == tab ?
                                        .system(size: 15, weight: .medium) :
                                        .system(size: 12, weight: .regular))
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
