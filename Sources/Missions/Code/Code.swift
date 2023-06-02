//
//  File.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/2/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import CodeScanner
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

    @State var presented = false
    var body: some View {
        VStack(spacing: 24) {
            MissionPropertiesGroupView(header: "Set Up") {
                Button {
                    presented = true
                } label: {
                    HStack {
                        Text("Choose Code")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .dynamicVerticalPadding()
                     
                        Image(systemName: "camera.fill")
                    }
                        .dynamicHorizontalPadding()
                }
            }
            .dynamicHorizontalPadding()
        }
        .sheet(isPresented: $presented) {
            CodeScanner()
        }
    }
}

struct CodeScanner: View {
    var body: some View {
        NavigationStack {
            Color.clear
                .overlay(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Scan a barcode or QR code.")
                            .font(.headline)

                        Text("Look for a cereal box or something.")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .dynamicVerticalPadding()
                    .dynamicHorizontalPadding()
                    .background {
                        Rectangle()
                            .fill(.regularMaterial)
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white, lineWidth: 4)
                        .shadow(
                            color: Color.black.opacity(0.25),
                            radius: 16,
                            x: 0,
                            y: 10
                        )
                        .frame(maxWidth: 300, maxHeight: 180)
                        .dynamicHorizontalPadding()
                        .dynamicHorizontalPadding()
                }
                .background {
                    VStack {
                        Divider()
                        
                        CodeScannerView(codeTypes: [.code128, .ean13, .upce, .code39]) { result in
                            print("Result: \(result)")
                        }
                        .ignoresSafeArea()
                    }
                }
                .navigationTitle("Scan Code")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarCloseButton()
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
            Text("Code")
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

struct ToolbarCloseButtonModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    var placement: ToolbarItemPlacement

    func body(content: Self.Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: placement) {
                    ToolbarCloseButton {
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
    }
}

struct ToolbarCloseButton: View {
    var action: (() -> Void)?
    var body: some View {
        Button {
            action?()
        } label: {
            Circle()
#if os(iOS)
                .fill(Color(uiColor: .quaternarySystemFill))
#endif
                .frame(width: 32)
                .overlay(
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                        .foregroundColor(.primary.opacity(0.5))
                )
        }
    }
}

extension View {
    func toolbarCloseButton(placement: ToolbarItemPlacement = .navigationBarTrailing) -> some View {
        self.modifier(ToolbarCloseButtonModifier(placement: placement))
    }
}
