//
//  MapServiceProvider.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 02.09.2023.
//

import Foundation
import CoreLocation
import MapKit

protocol MapServiceProviding {
    var regionProvider: Published<MKCoordinateRegion>.Publisher { get }
    func checkIfLocationIsEnable() async -> Bool
}

class MapServiceProvider: ObservableObject, MapServiceProviding {
    
    @Published private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 30), span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6))
    var regionProvider: Published<MKCoordinateRegion>.Publisher { $region }
    
    private var locationManager: CLLocationManager?
    
    func checkIfLocationIsEnable() async -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            let isGetedRegion = await checkLocationAuthorization()
            return isGetedRegion
        } else {
            print("location is hiden")
            return false
        }
    }
    
    private func checkLocationAuthorization() async -> Bool {
        guard let locationManager = locationManager else { return false }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return false
        case .restricted:
            print("restricted")
            return false
        case .denied:
            print("go to settings")
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 50, longitude: 30), span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6))
            }
            return true
        @unknown default:
            return false
        }
    }
}
