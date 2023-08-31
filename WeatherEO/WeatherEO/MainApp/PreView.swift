//
//  PreView.swift
//  WeatherEO
//
//  Created by Igor Kononov on 31.08.2023.
//

import SwiftUI

struct PreView: View {
    @State var showPreView = true
    
    var body: some View {
        ZStack {
            Color("green_Color")
                .ignoresSafeArea()
            
            Image("App_Image")
                .resizable()
                .frame(width: ScreenSize.width, height: ScreenSize.width)
                .cornerRadius(20)
           
        }
        .opacity(showPreView ? 1 : 0)
        .animation(.easeInOut(duration: 1.5))
        .onAppear() {
            withAnimation() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showPreView = false
                }
            }
        }
    }
}

struct PreView_Previews: PreviewProvider {
    static var previews: some View {
        PreView()
    }
}
