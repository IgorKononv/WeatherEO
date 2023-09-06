//
//  ShareView.swift
//  WeatherEO
//
//  Created by Igor Kononov on 31.08.2023.
//

import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    var shareText: String

    func makeUIViewController(context: Context) -> UIActivityViewController {
            let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No need for update as we're not changing anything
    }
}
