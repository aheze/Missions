//
//  BlocksMissionView.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/30/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import Prism
import SwiftUI

// MARK: - Mission view

struct BlocksMissionView: View {
    @Environment(\.tintColor) var tintColor
    @Environment(\.debugMode) var debugMode
    @Environment(\.missionCompletion) var missionCompletion
    @Environment(\.missionUserInteractionOccurred) var missionUserInteractionOccurred
    @Environment(\.missionCompleted) var missionCompleted

    var properties: BlocksMissionProperties

    @StateObject var model = SwiftUICraftViewModel()
    @StateObject var overlayModel = SwiftUICraftViewModel()

    @State var overlayExpanded = true
    @State var overlayAlignment = Alignment.topLeading
    @State var initialized = false

    var body: some View {
        VStack(spacing: 0) {
            GameView(model: model)
                .onAppear {
                    model.blocksUpdated = {
                        handleAddedBlock()
                    }
                }
                .overlay {
                    VStack(spacing: 20) {
                        if !missionCompleted {
                            GeometryReader { geometry in
                                Color.clear
                                    .overlay(alignment: overlayAlignment) {
                                        BlocksMissionOverlayView(
                                            model: overlayModel,
                                            availableSize: geometry.size,
                                            overlayExpanded: $overlayExpanded,
                                            overlayAlignment: $overlayAlignment
                                        )
                                    }
                            }
                            .dynamicHorizontalPadding()
                        }
                    }
                    .padding(.bottom, 20)
                }
                .onAppear {
                    model.selectedItem = .grass
                }

            if !missionCompleted {
                toolbar
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            guard !initialized else { return }
            initialized = true

            let world: World = {
                if let name = properties.selectedPresetName {
                    if
                        let presetString = properties.selectedPresetString,
                        let preset = WorldParser.getPreset(string: presetString)
                    {
                        return preset.world
                    } else if let preset = WorldPreset.allPresets.first(where: { $0.name == name }) {
                        return preset.world
                    }
                }
                
                /// fallback to random
                let random = WorldPreset.allPresets.randomElement() ?? WorldPreset(name: "Status", world: WorldParser.process(string: WorldParser.statue))
                return random.world

            }()

            var items = world.getContainingBlockKinds().compactMap { $0.associatedItem }
            items.append(.pick)

            let maxLevitation = world.getBlocksMaximumLevitation()

            let initialOffset = CGFloat(maxLevitation + 1) * model.blockLength

            model.level = Level(
                world: World(width: world.width, height: world.height, blocks: []),
                items: items,
                background: []
            )

            overlayModel.level = Level(
                world: world,
                items: items,
                background: []
            )

            overlayModel.maxLevitationShown = maxLevitation
            
            model.setBlocks(blocks: model.level.world.blocks)
            overlayModel.setBlocks(blocks: overlayModel.level.world.blocks)

            model.initialYOffset = 100 + initialOffset * 0.2
            overlayModel.initialYOffset = initialOffset

            model.objectWillChange.send()
            overlayModel.objectWillChange.send()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let first = items.first {
                    model.selectedItem = first
                }
            }
        }
        .onChange(of: missionCompleted) { newValue in
            if newValue {
                withAnimation(.spring(response: 0.6, dampingFraction: 1, blendDuration: 1)) {
                    overlayExpanded = false
                }
            }
        }
    }

    var toolbar: some View {
        OverflowLayout(spacing: 0) {
            ForEach(model.level.items, id: \.self) { item in
                let selected = model.selectedItem == item

                Button {
                    model.selectedItem = item
                } label: {
                    itemView(item: item)
                        .frame(width: 80, height: 80)
                        .background {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(tintColor)
                                .opacity(selected ? 0.1 : 0)
                        }
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 36, style: .continuous))
        .environment(\.colorScheme, .light)
    }

    func itemView(item: Item) -> some View {
        VStack {
            switch item.preview {
            case let .image(image):
                Image(image, bundle: .module)
                    .interpolation(.none)
                    .resizable()
                    .padding(18)
                    .offset(y: -3)
            case let .blockView(blockView):
                PrismCanvas(tilt: 1) {
                    blockView
                }
                .scaleEffect(y: 0.69)
                .offset(y: 8)
            }
        }
    }

    func handleAddedBlock() {
        missionUserInteractionOccurred?()

        if Set(model.level.world.blocks) == Set(overlayModel.level.world.blocks) {
            missionCompletion?()
        }
    }
}

struct BlocksMissionView_Previews: PreviewProvider {
    static var previews: some View {
        BlocksMissionView(properties: .init())
    }
}
