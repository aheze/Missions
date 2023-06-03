//
//  PhotoMissionPropertiesView.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/2/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

// MARK: - Mission properties view

struct PhotoMissionPropertiesView: View {
    @Binding var properties: PhotoMissionProperties
    @State var presentingCamera = false
    @State var loadingImage = false

    var body: some View {
        VStack(spacing: 24) {
            Button {
                presentingCamera = true
            } label: {
                VStack(spacing: 24) {
                    if loadingImage {
                        ProgressView()
                    } else {
                        if
                            let imageData = properties.imageData,
                            let image = UIImage(data: imageData)
                        {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80)
                                .mask {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                }

                        } else {
                            Image(systemName: "camera.shutter.button.fill")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }

                    Text(properties.imageData == nil ? "Tap to take a photo" : "Change photo")
                        .font(.title3)
                }
                .foregroundColor(.accentColor)
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

            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Snap your first activity of the day.")
                        .font(.headline)

                    Text("Examples:")
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 8) {
                    imageCell(title: "Sink", imageName: "sink")
                    imageCell(title: "Yoga Ball", imageName: "ball")
                    imageCell(title: "Closet", imageName: "closet")
                }
            }
            .dynamicVerticalPadding()
            .dynamicHorizontalPadding()
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.thinMaterial)
            }
            .fullScreenCover(isPresented: $presentingCamera) {
                ImagePickerView(sourceType: .camera) { image in
                    processImage(image: image)
                }
                .ignoresSafeArea()
            }
        }
        .missionPropertiesInvalidReason(reason: properties.featurePrintData == nil ? "Take a photo first" : nil)
        .dynamicHorizontalPadding()
//        .errorAlert(error: $error)
    }

    @ViewBuilder func imageCell(title: String, imageName: String) -> some View {
        VStack(spacing: 6) {
            Color.clear
                .overlay {
                    Image(imageName, bundle: .module)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .mask {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                }
                .aspectRatio(1, contentMode: .fit)

            Text(title)
                .font(.callout)
                .foregroundColor(.secondary)
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
