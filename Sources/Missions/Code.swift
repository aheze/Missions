//
//  File.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/2/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

// MARK: - Mission properties

public struct CodeMissionProperties: Hashable, Codable {
    public var sensitivity = Double(0.5)
    
    public init(sensitivity: Double = Double(0.5)) {
        self.sensitivity = sensitivity
    }
}

// MARK: - Mission properties view

struct CodeMissionPropertiesView: View {
    @Binding var properties: CodeMissionProperties

    var body: some View {
        VStack(spacing: 24) {
            MissionPropertiesGroupView(header: "Add customization controls here") {}
        }
    }
}

// MARK: - Mission view

struct CodeMissionView: View {
    @Environment(\.debugMode) var debugMode
    @Environment(\.missionCompletion) var missionCompletion
    @Environment(\.missionUserInteractionOccurred) var missionUserInteractionOccurred

    var properties: CodeMissionProperties

    var body: some View {
        VStack {
            if debugMode {
                Button("Debug testing button") {}
            }
        }
    }
}

// MARK: - Previews

struct CodeMissionPropertiesViewPreview: View {
    @State var properties = CodeMissionProperties()

    var body: some View {
        ScrollView {
            CodeMissionPropertiesView(properties: $properties)
                .dynamicHorizontalPadding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

struct CodeMissionPropertiesViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        CodeMissionPropertiesViewPreview()
    }
}

struct CodeMissionView_Previews: PreviewProvider {
    static var previews: some View {
        CodeMissionView(properties: .init())
    }
}
