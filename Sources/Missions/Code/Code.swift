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
    public var codeString: String?

    public init(codeString: String? = nil) {
        self.codeString = codeString
    }
}

// MARK: - Mission properties view

struct CodeMissionPropertiesView: View {
    @Binding var properties: CodeMissionProperties

    @State var presentingCodeScanner = false
    @State var error: Error?

    var body: some View {
        VStack(spacing: 24) {
            MissionPropertiesGroupView(header: properties.codeString == nil ? "Set Up" : "Selected Code:") {
                Button {
                    presentingCodeScanner = true
                } label: {
                    HStack {
                        Text(properties.codeString ?? "Choose Code")
                            .foregroundColor(properties.codeString == nil ? Color.accentColor : .secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .dynamicVerticalPadding()

                        Image(systemName: "camera.fill")
                    }
                    .dynamicHorizontalPadding()
                }
            }
            .dynamicHorizontalPadding()
        }
        .missionPropertiesInvalidReason(reason: properties.codeString == nil ? "Select a code above first" : nil)
        .sheet(isPresented: $presentingCodeScanner) {
            SetupCodeScanner { result in

                switch result {
                case .success(let result):
                    print("r: \(result) -> \(result.string)")
                    presentingCodeScanner = false
                    properties.codeString = result.string
                case .failure(let error):
                    print("Error scanning code: \(error)")
                    self.error = error
                }
            }
        }
        .errorAlert(error: $error)
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
