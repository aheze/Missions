//
//  LightweightGameView.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/31/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import Prism
import SwiftUI

struct LightweightGameView: View {
    var world: World
    var tilt: CGFloat
    var scale = CGFloat(1)
    var initialYOffset = CGFloat(10)
    var offset = CGSize.zero
    var allowsBlockManipulation = true
    var blockLength = CGFloat(50)

    @State var additionalTranslation = CGFloat(0)
    @State var savedTranslation = CGFloat(0)

    var body: some View {
        Color.clear
            .overlay {
                game
                    .disabled(!allowsBlockManipulation)
                    .scaleEffect(scale)
                    .offset(y: initialYOffset) /// Start off slightly downwards so that everything is visible.
            }
            .offset(offset) /// Up/down/left/right,
            .drawingGroup()
            .contentShape(Rectangle())
            .simultaneousGesture( /// For changing the tilt / POV.
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        additionalTranslation = value.translation.width
                    }
                    .onEnded { value in
                        savedTranslation += additionalTranslation
                        additionalTranslation = 0
                    }
            )
    }

    var game: some View {
        PrismCanvas(tilt: tilt) {
            let size = CGSize(
                width: CGFloat(world.width) * blockLength,
                height: CGFloat(world.height) * blockLength
            )

            /// Add a white base.
            PrismColorView(tilt: tilt, size: size, extrusion: 6, levitation: -6, color: Color.white)
                .overlay {
                    /// Enumerate over all blocks in the world and display them.
                    /// `model.level.world.blocks` must be sorted ascending for the 3D illusion to work.
                    ZStack(alignment: .topLeading) {
                        ForEach(world.blocks, id: \.hashValue) { block in
                            BlockView(
                                selectedItem: .pick,
                                tilt: tilt,
                                length: blockLength,
                                levitation: CGFloat(block.coordinate.levitation) * blockLength,
                                block: block
                            ) /** topTapped */ {} leftTapped: {} rightTapped: {} held: {}
                                .offset( /// Position the block.
                                    x: CGFloat(block.coordinate.column) * blockLength,
                                    y: CGFloat(block.coordinate.row) * blockLength
                                )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
        }
        .scaleEffect(y: 0.69) /// Make everything a bit squished for a perspective illusion.
    }
}
