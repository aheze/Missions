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

    public init(sensitivity: Double = Double(0.5)) {
        self.sensitivity = sensitivity
    }
}

// MARK: - Mission properties view

 struct PhotoMissionPropertiesView: View {
    @Binding var properties: PhotoMissionProperties

    var body: some View {
        VStack(spacing: 24) {
            MissionPropertiesGroupView(header: "Add customization controls here") {}
        }
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
