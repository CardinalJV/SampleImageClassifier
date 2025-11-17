//
//  FoodCameraViewModel.swift
//  MealDetector
//
//  Created by Viranaiken Jessy on 10/11/25.
//

import SwiftUI
import Combine

final class FoodCameraViewModel: ObservableObject {
    // Label of the meal
    @Published var predictionLabel: String = "No meal detected"
    // Confidence score of the result
    @Published var confidenceText: String = ""
    // Init the classifier
    private let classifier = MealClassifier()
    private var isProcessing = false
    // Launch the frame prediction
    func handleFrame(_ pixelBuffer: CVPixelBuffer) {
        // Verify if the frame is not already analysing
        guard !isProcessing else { return }
        isProcessing = true
        // Launch the classify prediction
        classifier?.classify(pixelBuffer: pixelBuffer) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isProcessing = false
                
                switch result {
                case .success(let (label, confidence)):
                    self.predictionLabel = label
                    self.confidenceText = "Confiance: \(Int(confidence * 100))%"
                case .failure:
                    self.predictionLabel = "Aucun plat détecté"
                    self.confidenceText = ""
                }
            }
        }
    }
}
