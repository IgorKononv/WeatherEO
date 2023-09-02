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
    func checkIfLocationIsEnable() async
}

class MapServiceProvider: ObservableObject, MapServiceProviding {
    
    @Published private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 30), span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6))
    var regionProvider: Published<MKCoordinateRegion>.Publisher { $region }
    
    private var locationManager: CLLocationManager?
    
    func checkIfLocationIsEnable() async {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            checkLocationAuthorization()
        } else {
            print("location is hiden")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("go to settings")
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 50, longitude: 30), span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6))
            }
        @unknown default:
            break
        }
    }
}
