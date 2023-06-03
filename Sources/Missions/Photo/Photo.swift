//
//  File.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/2/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

// MARK: - Mission properties

public struct PhotoMissionProperties: Hashable, Codable {
    public var sensitivity = Double(0.5)
    public var imageData: Data?
    public var featurePrintData: Data?

    public init(sensitivity: Double = Double(0.5), imageData: Data? = nil, featurePrintData: Data? = nil) {
        self.sensitivity = sensitivity
        self.imageData = imageData
        self.featurePrintData = featurePrintData
    }
}

// MARK: - Mission properties view

struct PhotoMissionPropertiesView: View {
    @Binding var properties: PhotoMissionProperties
    @State var presentingCamera = false

    var body: some View {
        VStack(spacing: 24) {
            Button {
                presentingCamera = true
            } label: {
                VStack(spacing: 24) {
                    Image(systemName: "camera.shutter.button.fill")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Tap to take a photo")
                        .font(.title3)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.vertical, 48)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.thinMaterial)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Color.primary, style: .init(lineWidth: 0.25, lineCap: .round, dash: [5], dashPhase: 2))
                        .opacity(0.5)
                }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text("Take a photo of a prominent object.")

                Text("Examples:")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .dynamicVerticalPadding()
            .dynamicHorizontalPadding()
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.thinMaterial)
            }
//            .sheet(isPresented: $presentingCodeScanner) {
//                SetupCodeScanner { result in
//
//                    switch result {
//                    case .success(let result):
//                        print("r: \(result) -> \(result.string)")
//                        presentingCodeScanner = false
//                        properties.codeString = result.string
//                    case .failure(let error):
//                        print("Error scanning code: \(error)")
//                        self.error = error
//                    }
//                }
//            }
//
        }
        .missionPropertiesInvalidReason(reason: properties.featurePrintData == nil ? "Take a photo first" : nil)
        .dynamicHorizontalPadding()
//        .errorAlert(error: $error)
    }
}

// MARK: - Mission view

struct PhotoMissionView: View {
    @Environment(\.debugMode) var debugMode
    @Environment(\.missionCompletion) var missionCompletion
    @Environment(\.missionUserInteractionOccurred) var missionUserInteractionOccurred

    var properties: PhotoMissionProperties

    var body: some View {
        VStack {
            if debugMode {
                Button("Debug testing button") {}
            }
        }
    }
}

// MARK: - Previews

struct PhotoMissionPropertiesViewPreview: View {
    @State var properties = PhotoMissionProperties()

    var body: some View {
        ScrollView {
            PhotoMissionPropertiesView(properties: $properties)
                .dynamicHorizontalPadding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

struct PhotoMissionPropertiesViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        PhotoMissionPropertiesViewPreview()
    }
}

struct PhotoMissionView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoMissionView(properties: .init())
    }
}
