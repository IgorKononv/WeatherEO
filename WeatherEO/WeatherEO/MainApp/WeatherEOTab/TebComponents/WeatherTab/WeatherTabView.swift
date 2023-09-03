//
//  WeatherTabView.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 03.09.2023.
//

import SwiftUI

struct WeatherTabView: View {
    @StateObject var viewModel = WeatherTabViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct WeatherTabView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherTabView()
    }
}
