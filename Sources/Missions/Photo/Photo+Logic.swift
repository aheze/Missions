//
//  File.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/2/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//
    
import SwiftUI
import Vision

extension PhotoMissionPropertiesView {
    func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let data = image.jpegData(compressionQuality: 0.2)
            let observation = featurePrintObservationForImage(cgImage: cgImage)
            
            DispatchQueue.main.async {
                var properties = self.properties
                if let data {
                    properties.imageData = data
                    
                } else {
                    print("No image preview data.")
                }
                
                if let observation {
                    properties.featurePrintData = observation.data
                } else {
                    print("No feature print data.")
                }
                
                self.properties = properties
            }
        }
    }
    
    func featurePrintObservationForImage(cgImage: CGImage) -> VNFeaturePrintObservation? {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNGenerateImageFeaturePrintRequest()
        do {
            try requestHandler.perform([request])
            return request.results?.first as? VNFeaturePrintObservation
        } catch {
            print("Vision error: \(error)")
            return nil
        }
    }
}
