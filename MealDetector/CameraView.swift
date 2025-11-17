//
//  CameraView.swift
//  MealDetector
//
//  Created by Viranaiken Jessy on 10/11/25.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    // Allow swiftUI to observe the viewmodel
    @ObservedObject var viewModel: FoodCameraViewModel
    // Allow the viewmodel to handle the CameraViewController
    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.onFrame = { pixelBuffer in
            viewModel.handleFrame(pixelBuffer)
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        // No dynamic updates needed for now
    }
}
