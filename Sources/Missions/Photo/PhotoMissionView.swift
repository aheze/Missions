//
//  File.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/2/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

// MARK: - Mission view

struct PhotoMissionView: View {
    @Environment(\.debugMode) var debugMode
    @Environment(\.missionCompletion) var missionCompletion
    @Environment(\.missionUserInteractionOccurred) var missionUserInteractionOccurred

    var properties: PhotoMissionProperties
    @State var presentingCamera = false
    @State var image: UIImage?

    @State var failedToGetDistance = false
    @State var error: Error?
    @State var processingImage = false
    @State var previousAttemptImageDistance: Float?
    var imageDistanceMaximumThreshold = Float(16)

    var body: some View {
        VStack(spacing: 20) {
            Text("Take a photo of this!")
                .font(.title3)
                .opacity(0.5)

            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120)
                    .mask {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                    }
            }

            if let previousAttemptImageDistance {
                let points = String(format: "%.2f", previousAttemptImageDistance)
                
                VStack(spacing: 16) {
                    Text("Photo doesn't match, try again!")
                    
                    Text("Difference score: \(points), aim for 15 or lower.")
                }
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .dynamicHorizontalPadding()
            }

            Button {
                missionUserInteractionOccurred?()
                presentingCamera = true
            } label: {
                Text("Take Photo")
                    .foregroundColor(.accentColor)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background {
                        Capsule(style: .continuous)
                            .fill(Color.accentColor)
                            .opacity(0.1)
                    }
            }

            if failedToGetDistance {
                Text("Error computing image similarity, please report a bug.")

                Button("Finish Mission") {
                    missionCompletion?()
                }
            }

            Spacer()
        }
        .sheet(isPresented: $presentingCamera) {
            ImagePickerView(sourceType: .camera) { image in
                processImage(image: image)
            }
            .ignoresSafeArea()
            .presentationDetents([.medium, .large])
        }
        .onAppear {
            if
                let imageData = properties.imageData,
                let image = UIImage(data: imageData)
            {
                self.image = image
            }
        }
        .errorAlert(error: $error)
    }
}

struct PhotoMissionView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoMissionView(properties: .init())
    }
}
