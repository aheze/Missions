//
//  File.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/2/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//
    
import CoreML
import SwiftUI
import Vision

extension PhotoMissionPropertiesView {
    func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        withAnimation {
            loadingImage = true
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let data = image.jpegData(compressionQuality: 0.2)
            let observation = PhotoMissionProperties.featurePrintObservationForImage(cgImage: cgImage)
            
            DispatchQueue.main.async {
                var properties = self.properties
                if let data {
                    properties.imageData = data
                    
                } else {
                    print("No image preview data.")
                }
                
                if let observation {
                    do {
                        let data = try NSKeyedArchiver.archivedData(withRootObject: observation, requiringSecureCoding: true)
                        properties.featurePrintData = data
                    } catch {
                        print("Couldn't get feature print data encoded: \(error)")
                    }
                } else {
                    print("No feature print data.")
                }
                
                self.properties = properties
                
                withAnimation {
                    loadingImage = false
                }
            }
        }
    }
}

extension PhotoMissionView {
    func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        guard let originalFeaturePrintData = properties.featurePrintData else { return }
        
        withAnimation {
            processingImage = true
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let observation = PhotoMissionProperties.featurePrintObservationForImage(cgImage: cgImage) else {
                print("Couldn't get new observation.")
                return
            }
            
            let distance: Float? = {
                var distance = Float(0)
            
                do {
                    if let originalFeaturePrintObservation = try NSKeyedUnarchiver.unarchivedObject(ofClass: VNFeaturePrintObservation.self, from: originalFeaturePrintData) {
                        try originalFeaturePrintObservation.computeDistance(&distance, to: observation)
                    
                        print("Distance: \(distance)")
                        return distance
                    } else {
                        print("None")
                    }
                } catch {
                    print("Error decoding or computing distance: \(error)")
                    DispatchQueue.main.async {
                        self.error = error
                    }
                }
                return nil
            }()
            
            DispatchQueue.main.async {
                withAnimation {
                    if let distance {
                        if distance < imageDistanceMaximumThreshold {
                            missionCompletion?()
                        } else {
                            previousAttemptImageDistance = distance
                        }
                    } else {
                        print("Failed to get distance.")
                        failedToGetDistance = true
                    }
                
                    processingImage = false
                }
            }
        }
    }
}

extension PhotoMissionProperties {
    static func featurePrintObservationForImage(cgImage: CGImage) -> VNFeaturePrintObservation? {
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
