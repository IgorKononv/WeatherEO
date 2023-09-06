//
//  DeleteListComponent.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 04.09.2023.
//

import SwiftUI

struct DeleteListComponent: View {
    @ObservedObject var viewModel: ListWeatherViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(20)
                .frame(width: ScreenSize.width * 0.85 + 5, height: 225)
            Rectangle()
                .foregroundColor(Color("pink_Color"))
                .cornerRadius(20)
                .frame(width: ScreenSize.width * 0.85, height: 220)
            VStack {
                Text("Are you absolutely certain you wish to remove the selected city?")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .semibold))
                
                Image("delete_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                
                    Spacer()
                HStack {
                    Button {
                        viewModel.doDeleteCity()
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: ScreenSize.width * 0.38 + 2, height: 40)
                                .foregroundColor(.black)
                                .cornerRadius(20)
                            Rectangle()
                                .frame(width: ScreenSize.width * 0.38, height: 38)
                                .foregroundColor(.red)
                                .cornerRadius(20)
                                .opacity(0.9)
                            Text("Delete")
                                .foregroundColor(.white)
                        }
                    }
                    Button {
                        viewModel.cancelDeletingCity()
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: ScreenSize.width * 0.38 + 2, height: 40)
                                .foregroundColor(.black)
                                .cornerRadius(20)
                            Rectangle()
                                .frame(width: ScreenSize.width * 0.38, height: 38)
                                .foregroundColor(.green)
                                .cornerRadius(20)
                                .opacity(0.9)
                            Text("Cancel")
                                .foregroundColor(.white)
                        }
                    }

                }
            }
            .padding()
            .padding(.vertical, 20)
            
        }
        .frame(width: ScreenSize.width * 0.85, height: 250)
        .offset(y: viewModel.showDeleteAlert ? 0 : ScreenSize.height / 1.5)
    }
}

struct DeleteListComponent_Previews: PreviewProvider {
    static var previews: some View {
        DeleteListComponent(viewModel: ListWeatherViewModel())
    }
}
