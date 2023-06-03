//
//  Blocks.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/29/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

// MARK: - Mission properties

public struct BlocksMissionProperties: Codable, Hashable {
    public var selectedPresetName: String?

    public init(selectedPresetName: String? = nil) {
        self.selectedPresetName = selectedPresetName
    }
}

// MARK: - Mission properties view

struct BlocksMissionPropertiesView: View {
    @Binding var properties: BlocksMissionProperties

    @State var code = ""
    @State var errorString: String?

    @AppStorage("importedWorlds") @Storage var importedWorlds = [String]()

    var importedPresets: [WorldPreset] {
        importedWorlds.compactMap { WorldParser.getPreset(string: $0) }
    }

    let allowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")

    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 200), spacing: 12, alignment: .top)
    ]

    var body: some View {
        VStack(spacing: 24) {
            let binding = Binding {
                code
            } set: { newValue in
                guard newValue.count <= 6 else { return }

                let characterSet = CharacterSet(charactersIn: newValue)
                if allowedCharacters.isSuperset(of: characterSet) {
                    code = newValue.uppercased()
                }
            }

            MissionPropertiesGroupView(header: "Import from Code", footer: "6-digit alphanumeric code") {
                TextField("Enter Code", text: binding)
                    .onSubmit {
                        print("code: \(code)")

                        importFromCode(code: code)
                    }
                    .textFieldStyle(.plain)
                    .dynamicVerticalPadding()
                    .dynamicHorizontalPadding()
            }
            .dynamicHorizontalPadding()

            if !importedPresets.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Imported Worlds")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .textCase(.uppercase)
                        .dynamicHorizontalPadding()

                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(importedPresets) { preset in
                            BlocksMissionPresetView(properties: $properties, preset: preset)
                        }
                    }
                    .dynamicHorizontalPadding()
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("... or select a preset")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .textCase(.uppercase)
                    .dynamicHorizontalPadding()

                LazyVGrid(columns: columns, spacing: 16) {
                    BlocksMissionPresetView(properties: $properties, preset: nil)

                    ForEach(WorldPreset.allPresets) { preset in
                        BlocksMissionPresetView(properties: $properties, preset: preset)
                    }
                }
                .dynamicHorizontalPadding()
            }
        }
        .frame(maxWidth: .infinity)
        .alert("Error Importing", isPresented: Binding {
            errorString != nil
        } set: { _ in
            errorString = nil
        }) {
            Button("Ok") {}
        } message: {
            if let errorString {
                Text(errorString)
            }
        }
        .onAppear {
            let debugString = """
            Ice Gold
            3x3

            ice ice ice
            ice x ice
            ice ice ice

            gold gold gold
            gold gold gold
            gold gold gold
            """
            if !importedPresets.contains(where: { $0.name == "" }) {
                importedWorlds.append(debugString)
            }
        }
    }

    func importFromCode(code: String) {
        if code.count != 6 {
            errorString = "Code must be 6 digits."
            return
        }

        let characterSet = CharacterSet(charactersIn: code)
        if !allowedCharacters.isSuperset(of: characterSet) {
            errorString = "Code must be alphanumeric (0-9, A-Z)."
            return
        }

        downloadWithCode(code: code) { string in
        }
    }

    func downloadWithCode(code: String, completion: @escaping ((String?) -> Void)) {}
}

struct BlocksMissionPresetView: View {
    @Binding var properties: BlocksMissionProperties
    var preset: WorldPreset?

    var body: some View {
        Button {
            properties.selectedPresetName = preset?.name
        } label: {
            content
        }
    }

    @ViewBuilder var content: some View {
        let selected = properties.selectedPresetName == preset?.name

        VStack(spacing: 12) {
            VStack {
                if let preset {
                    LightweightGameView(world: preset.world, tilt: 0.3, scale: 1, initialYOffset: 10, blockLength: 10)
                        .disabled(true)
                } else {
                    Image(systemName: "questionmark")
                        .font(.largeTitle)
                        .foregroundColor(selected ? .accentColor : .secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(height: 100)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .mask {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
            }
            .overlay {
                if selected {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.accentColor, lineWidth: 3)
                }
            }
            .shadow(
                color: .black.opacity(0.1),
                radius: 16,
                x: 0,
                y: 10
            )

            Text(preset?.name ?? "Random")
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Previews

struct BlocksMissionPropertiesViewPreview: View {
    @State var properties = BlocksMissionProperties()

    var body: some View {
        ScrollView {
            BlocksMissionPropertiesView(properties: $properties)
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

struct BlocksMissionPropertiesViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        BlocksMissionPropertiesViewPreview()
    }
}
