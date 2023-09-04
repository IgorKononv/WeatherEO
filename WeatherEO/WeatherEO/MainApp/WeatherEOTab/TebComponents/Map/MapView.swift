//
//  MapView.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 31.08.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var viewModel = MapViewModel()
    @AppStorage("temperatureScaleModel_ID") var scaleMod: TemperatureScaleModel = .fahrenheit

    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.customAnnotation, annotationContent: { location in MapAnnotation(coordinate: location.coordinate) {
                
                    Button {
                        viewModel.openMoreMapPointInfo(location)
                    } label: {
                        VStack(spacing: -1) {
                            ZStack {
                                Circle()
                                    .frame(height: location.isBigInfoCircle ? 82 : 42)
                                    .foregroundColor(.black)
                                Circle()
                                    .frame(height: location.isBigInfoCircle ? 80 : 40)
                                    .foregroundColor(.gray)
                                
                                VStack(spacing: 0) {
                                    Text("\(scaleMod == .celsius ? Int(location.temp - 273.15) : Int((location.temp - 273.15) * 9/5 + 32))")
                                        .foregroundColor(.white)
                                        .bold()
                                    
                                    if location.isBigInfoCircle {
                                        VStack(spacing: 0) {
                                            Image(location.image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 50)
                                        }
                                    }
                                }
                            }
                            Image(systemName: "triangle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 10)
                                .rotationEffect(.degrees(180))
                                .foregroundColor(scaleMod == .fahrenheit ? .red : .blue)
                        }
                    }
                    .offset(y: location.isBigInfoCircle ? -45 : -25)
                    .frame(width: 100, height: 150)
            }})
            MapSearchBar(viewModel: viewModel)
        }
        .onTapGesture {
            viewModel.unDoFocusToTextField()
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.checkIfLocationIsEnable()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

