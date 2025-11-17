//
//  FoodCameraView.swift
//  MealDetector
//
//  Created by Viranaiken Jessy on 10/11/25.
//

import SwiftUI

struct FoodCameraView: View {
    @StateObject private var viewModel = FoodCameraViewModel()
    private var cameraViewController = CameraViewController()
    var body: some View {
        ZStack(alignment: .bottom) {
            CameraView(viewModel: viewModel)
                .ignoresSafeArea()
            VStack(spacing: 8) {
                Text(viewModel.predictionLabel)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                if !viewModel.confidenceText.isEmpty {
                    Text(viewModel.confidenceText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(12)
            .padding()
        }
    }
}

#Preview {
    FoodCameraView()
}
