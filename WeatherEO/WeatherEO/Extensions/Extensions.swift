//
//  Extensions.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 03.09.2023.
//

import SwiftUI

extension View {
    func sync<T: Equatable>(_ binding: Binding<T>, with focusState: FocusState<T>) -> some View {
        self
            .onChange(of: binding.wrappedValue) {
                focusState.wrappedValue = $0
            }
            .onChange(of: focusState.wrappedValue) {
                binding.wrappedValue = $0
            }
    }
}
