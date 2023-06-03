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

class BlocksMissionPropertiesModel: ObservableObject {
    @AppStorage("importedWorlds") @Storage var importedWorlds = [String]()
    @Published var importedPresets = [WorldPreset]()

    let allowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
    @Published var code = ""

    @Published var errorString: String?

    func updatePresetsFromImportedWorlds(worlds: [String]) {
        let importedPresets = worlds.compactMap { WorldParser.getPreset(string: $0) }
        print("From \(worlds.count) -> \(importedPresets.count)")
        self.importedPresets = importedPresets
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

struct BlocksMissionPropertiesView: View {
    @Binding var properties: BlocksMissionProperties

    @StateObject var model = BlocksMissionPropertiesModel()
    @State var confirmingDeleteAll = false

    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 200), spacing: 12, alignment: .top)
    ]

    var body: some View {
        VStack(spacing: 48) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Select a world")
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

            importFromCodeView
        }
        .frame(maxWidth: .infinity)
        .alert("Error Importing", isPresented: Binding {
            model.errorString != nil
        } set: { _ in
            model.errorString = nil
        }) {
            Button("Ok") {}
        } message: {
            if let errorString = model.errorString {
                Text(errorString)
            }
        }
        .alert("Delete all imported worlds?", isPresented: $confirmingDeleteAll) {
            Button("Delete All", role: .destructive) {
                model.importedWorlds = []
            }

        } message: {
            Text("You can't undo this action.")
        }
        .onAppear {
            model.importedWorlds = []
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
            if !model.importedPresets.contains(where: { $0.name == "Ice Gold" }) {
                model.importedWorlds.append(debugString)
                model.updatePresetsFromImportedWorlds(worlds: model.importedWorlds)
            }
        }
        .onChange(of: model.importedWorlds) { newValue in
            model.updatePresetsFromImportedWorlds(worlds: newValue)
        }
    }

    @ViewBuilder var importFromCodeView: some View {
        let binding = Binding {
            model.code
        } set: { newValue in
            guard newValue.count <= 6 else { return }

            let characterSet = CharacterSet(charactersIn: newValue)
            if model.allowedCharacters.isSuperset(of: characterSet) {
                model.code = newValue.uppercased()
            }
        }

        VStack(spacing: 24) {
            MissionPropertiesGroupView(header: "Or import from code", footer: "6-digit alphanumeric code") {
                TextField("Enter Code", text: binding)
                    .onSubmit {
                        print("Entered code: \(model.code)")

                        model.importFromCode(code: model.code)
                    }
                    .textFieldStyle(.plain)
                    .dynamicVerticalPadding()
                    .dynamicHorizontalPadding()
            }
            .dynamicHorizontalPadding()

            if !model.importedPresets.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Imported Worlds")
                            .textCase(.uppercase)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Button("Delete All", role: .destructive) {
                            confirmingDeleteAll = true
                        }
                    }
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .dynamicHorizontalPadding()

                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(model.importedPresets) { preset in

                            let binding: Binding<[String]> = Binding {
                                model.importedWorlds
                            } set: { newValue in
                                model.importedWorlds = newValue
                            }

                            BlocksMissionImportedPresetView(importedWorlds: binding, properties: $properties, preset: preset)
                        }
                    }
                    .dynamicHorizontalPadding()
                }
            }
        }
    }
}

struct BlocksMissionImportedPresetView: View {
    @Binding var importedWorlds: [String]
    @Binding var properties: BlocksMissionProperties
    var preset: WorldPreset?

    @State var confirmingDeletion = false

    var body: some View {
        BlocksMissionPresetView(properties: $properties, preset: preset)
            .dynamicOverlay(align: .topTrailing, to: .center) {
                Button {
                    confirmingDeletion = true
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .frame(width: 26, height: 26)
                        .background {
                            Circle()
                                .fill(.ultraThickMaterial)
                        }
                        .overlay {
                            Circle()
                                .stroke(Color.primary, lineWidth: 0.25)
                                .opacity(0.25)
                        }
                }
            }
            .alert("Delete \(preset?.name ?? "World")?", isPresented: $confirmingDeletion) {
                Button("Delete", role: .destructive) {
                    let presetName = preset?.name ?? ""

                    var importedWorlds = self.importedWorlds

                    /// trim out worlds that have the same name
                    importedWorlds = importedWorlds.filter { world in
                        let worldString = world.trimmingCharacters(in: .whitespacesAndNewlines)
                        let components = worldString.components(separatedBy: "\n")

                        if let title = components.first {
                            return title != presetName
                        } else {}

                        return true
                    }

                    self.importedWorlds = importedWorlds
                }

            } message: {
                Text("You can't undo this action.")
            }
    }
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
