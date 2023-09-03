//
//  ListSearchBar.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 03.09.2023.
//

import SwiftUI

struct ListSearchBar: View {
    @ObservedObject var viewModel: ListWeatherViewModel
    @FocusState var focus: Bool

    var body: some View {
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
                                .sync($viewModel.isFocusedTextField, with: _focus)

                            Spacer()
                            
                            Button {
                                withAnimation {
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
                                            viewModel.getWeatherOnList(item)
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
                Spacer()
                
                Button {
                    viewModel.openSettings()
                } label: {
                    Image("settings_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }
            }
            Spacer()
        }
    }
}

struct ListSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        ListSearchBar(viewModel: ListWeatherViewModel())
    }
}
