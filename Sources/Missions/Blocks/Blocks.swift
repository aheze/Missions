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

    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 200), spacing: 12, alignment: .top)
    ]

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Selected World")
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
                .dynamicHorizontalPadding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

struct BlocksMissionPropertiesViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        BlocksMissionPropertiesViewPreview()
    }
}
