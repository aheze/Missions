//
//  File.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/2/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

extension BlocksMissionView {
    func shuffle() {
        let random = WorldPreset.allPresets.randomElement() ?? WorldPreset(name: "Status", world: WorldParser.process(string: WorldParser.statue))
        let world = random.world
        setupForWorld(world: world)
    }

    func onAppear() {
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

        setupForWorld(world: world)
    }

    func setupForWorld(world: World) {
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
}
