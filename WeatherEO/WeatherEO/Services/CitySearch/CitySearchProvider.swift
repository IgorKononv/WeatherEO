//
//  CitySearchProvider.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 03.09.2023.
//

import Foundation

protocol CitySearchProviding {
    func searchCity(searchText: String) async -> [CitySearchModel]
}

class CitySearchProvider: CitySearchProviding {
    // https://api-ninjas.com/profile
    
    func searchCity(searchText: String) async -> [CitySearchModel] {
        let apiKey = "KePqiGfHzq1R5xCI6BXpcg==L6lE4bDl1GQW7FtN"
        let cityName = searchText
        let limit = 10
        
        let urlString = "https://api.api-ninjas.com/v1/city?name=" + cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            + "&limit=\(limit)"
        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let cities = try JSONDecoder().decode([CitySearchModel].self, from: data)
                return cities
            } catch {
                print("Error: \(error)")
                return []
            }
        } else {
            print("Invalid URL")
            return []
        }
    }
}
