//
//  CustomAnnotationModel.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 02.09.2023.
//

import Foundation
import MapKit

struct CustomAnnotationModel: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let temp: Double
    let image: String
    var isBigInfoCircle: Bool
    let fromCases: FromCases
    
}

enum FromCases {
    case realm
    case mapSearch
    case currentLocation
}
