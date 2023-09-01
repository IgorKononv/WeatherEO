//
//  MapViewModel.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 31.08.2023.
//

import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 30), span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6))
    
    func tapCancel() {
        searchText = ""
    }
    
    func tapSerch() {
        
    }
}
