//
//  CameraViewController.swift
//  MealDetector
//
//  Created by Viranaiken Jessy on 10/11/25.
//

import Foundation
import UIKit
import AVFoundation

final class CameraViewController: UIViewController {
    // Closure called for every frame from the camera
    var onFrame: ((CVPixelBuffer) -> Void)?
    // Init the capture session
    private let session = AVCaptureSession()
    // Convert the frames to CMSampleBuffer
    private let videoOutput = AVCaptureVideoDataOutput()
    // When the view is loaded, we configure the camera session
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSession()
        session.startRunning()
    }
    // Camera configuration
    private func setupSession() {
        // We start the configuration
        session.beginConfiguration()
        // Set the quality
        session.sessionPreset = .high
        // Verify if we can get the input data from the camera, otherwise return void and close the function
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back), let input = try? AVCaptureDeviceInput(device: device), session.canAddInput(input) else {
            session.commitConfiguration()
            return
        }
        // Adding the input camera to the session
        session.addInput(input)
        // Setting output for vision
        if session.canAddOutput(videoOutput){
            // Allow this controller to get frame output, dispatch on the different queue for better performance
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "CameraOutputQueue"))
            // Sort and delete the late frame
            videoOutput.alwaysDiscardsLateVideoFrames = true
            // Adding the output
            session.addOutput(videoOutput)
        }
        // Display the camera flux
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        // Fill the screen with keeping the proportions
        previewLayer.videoGravity = .resizeAspectFill
        // Allow the view to take all of the screen
        previewLayer.frame = view.bounds
        // Adding the preview on the controller view
        view.layer.addSublayer(previewLayer)
        // Start the session
        session.commitConfiguration()
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    // Called for every frame catched
    func captureOutput(_ output: AVCaptureOutput, didOutput samplbuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(samplbuffer) else {
            return
        }
        
        onFrame?(pixelBuffer)
    }
}
