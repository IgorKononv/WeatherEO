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
    @FocusState var focus: Bool
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
                                    Text("\(viewModel.temperatureScaleModel == .celsius ? Int(location.temp - 273.15) : Int((location.temp - 273.15) * 9/5 + 32))")
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
                                .foregroundColor(viewModel.temperatureScaleModel == .fahrenheit ? .red : .blue)
                        }
                    }
                    .offset(y: location.isBigInfoCircle ? -45 : -25)
                    .frame(width: 100, height: 150)
            }})
        
            VStack {
                ZStack(alignment: .bottom) {
                    ZStack(alignment: .top) {
                        Rectangle()
                            .frame(height: viewModel.matchingItems.isEmpty ? 110 : 410)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        
                        Rectangle()
                            .foregroundColor(Color("green_Color"))
                            .frame(height: viewModel.matchingItems.isEmpty ? 105 : 405)
                            .cornerRadius(20)
                    }
                    
                    VStack {
                        ZStack {
                            Rectangle()
                                .frame(height: 38)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            
                            HStack {
                                TextField("Search..", text: $viewModel.searchText)
                                    .onChange(of: viewModel.searchText, perform: { _ in
                                         viewModel.searchCity()
                                    })
                                    .focused($focus)
                                Spacer()
                                
                                Button {
                                    withAnimation {
                                        focus = false
                                        viewModel.tapCancel()
                                    }
                                } label: {
                                    Image("cancel_icon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 28)
                                        .opacity(viewModel.searchText.isEmpty ? 0.5 : 1)
                                }
                                .disabled(viewModel.searchText.isEmpty)
                            }
                            .padding(.horizontal)
                        }
                        
                        if !viewModel.matchingItems.isEmpty {
                            ZStack {
                                Rectangle()
                                    .frame(height: 300)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                                ScrollView {
                                    VStack(spacing: 10) {
                                        ForEach(viewModel.matchingItems, id: \.name) { item in
                                            Button {
                                                viewModel.getWeatherOnMap(item)
                                            } label: {
                                                HStack {
                                                    Text(item.name )
                                                        .foregroundColor(.black)
                                                    Spacer()
                                                    
                                                    Image("serch_icon")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: 25)
                                                }
                                            }
                                        }
                                    }
                                    .padding()
                                }
                            }
                            .frame(height: 300)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                
                HStack {
                    Button {
                        viewModel.navigateCurrentPositon()
                    } label: {
                        Image("navigation_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                    }
                    
                    Spacer()
                    Button {
                        viewModel.changeScale()
                    } label: {
                        Image(viewModel.temperatureScaleModel.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                    }
                }
                Spacer()
            }
        }
        .onTapGesture {
            focus = false
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
