//
//  MealClassifier.swift
//  MealDetector
//
//  Created by Viranaiken Jessy on 10/11/25.
//

import Vision
import CoreML

final class MealClassifier {
    
    private let model: VNCoreMLModel
    private let queue = DispatchQueue(label: "MealClassifierQueue")
    
    init?() {
        // Verify if the MLModel is available
        guard let coreMLModel = try? FoodClassifier(configuration: MLModelConfiguration()).model else {
            return nil
        }
        // Verfiy if a object vision can be create with the MLModel
        guard let model = try? VNCoreMLModel(for: coreMLModel) else {
            return nil
        }
        // Assign the previous model configuration to the main model
        self.model = model
    }
    // Create the request and manage the results with a completion handler, if the response does'nt exist return an error
    func classify(pixelBuffer: CVPixelBuffer, completion: @escaping (Result<(String, Double), Error>) -> Void) {
        // Create the vision request with the model assigned
        let request = VNCoreMLRequest(model: self.model) { request, error in
            // If the request get an error, return nil
            if let error = error {
                completion(.failure(error))
                return
            }
            // If the confidence is equal to zero, return a default completion
            guard let results = request.results as? [VNClassificationObservation], let firstResults = results.first else {
                completion(.success(("Inconnu", 0.0)))
                return
            }
            // If result get success
            completion(.success((firstResults.identifier, Double(firstResults.confidence))))
        }
        // Object that will use the request on the camera image
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        // Launch the request
        queue.async {
            do {
                try handler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }
}
