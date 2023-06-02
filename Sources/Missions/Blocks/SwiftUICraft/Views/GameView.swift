//
//  GameView.swift
//  SwiftUICraft
//
//  Created by A. Zheng (github.com/aheze) on 11/9/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import Prism
import SwiftUI

/**
 The 3D game content.

 It's all SwiftUI — no SceneKit, SpriteKit, or anything else!
 */
struct GameView: View {
    @ObservedObject var model: SwiftUICraftViewModel
    var scale: CGFloat?
    var offset: CGSize?
    var allowsBlockManipulation = true

    var body: some View {
        Color.clear
            .overlay {
                game
                    .disabled(!allowsBlockManipulation)
                    .scaleEffect(scale ?? model.scale)
                    .offset(y: model.initialYOffset) /// Start off slightly downwards so that everything is visible.
            }
            .offset(offset ?? model.offset) /// Up/down/left/right,
            .drawingGroup()
            .background {
                LinearGradient(colors: model.level.background.map { Color(uiColor: .init(hex: $0)) }, startPoint: .top, endPoint: .bottom)
            }
//            .ignoresSafeArea()
            .contentShape(Rectangle())
            .simultaneousGesture( /// For changing the tilt / POV.
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        model.additionalTranslation = value.translation.width
                    }
                    .onEnded { value in
                        model.savedTranslation += model.additionalTranslation
                        model.additionalTranslation = 0
                    }
            )
    }

    var game: some View {
        PrismCanvas(tilt: model.tilt) {
            let size = CGSize(
                width: CGFloat(model.level.world.width) * model.blockLength,
                height: CGFloat(model.level.world.height) * model.blockLength
            )

            /// Add a white base.
//            PrismColorView(tilt: model.tilt, size: size, extrusion: 20, levitation: -20, color: Color.white)

            PrismView(tilt: model.tilt, size: size, extrusion: 20, levitation: -20) {
                Color.white
                    .overlay {
                        VStack(spacing: 0) {
                            ForEach(0..<model.level.world.height, id: \.self) { row in
                                HStack(spacing: 0) {
                                    ForEach(0..<model.level.world.width, id: \.self) { column in
                                        Button {
                                            let coordinate = Coordinate(row: row, column: column, levitation: 0)
                                            model.addBlock(at: coordinate)
                                        } label: {
                                            Rectangle()
                                                .stroke(Color.black, lineWidth: 0.5)
                                                .opacity(0.25)
                                                .contentShape(Rectangle())
                                        }
                                    }
                                }
                            }
                        }
                    }
            } left: {
                Color.white.brightness(-0.1)
            } right: {
                Color.white.brightness(-0.3)
            }

            .overlay {
                /// Enumerate over all blocks in the world and display them.
                /// `model.level.world.blocks` must be sorted ascending for the 3D illusion to work.
                ZStack(alignment: .topLeading) {
                    let blocks: [Block] = {
                        
                        if model.tilt > 0 {
                            return model.level.world.blocks
                        } else {
                            return model.level.world.inverseBlocks
                        }
                    }()
                    
                    ForEach(blocks, id: \.hashValue) { block in
                        BlockView(
                            selectedItem: model.selectedItem,
                            tilt: model.tilt,
                            length: model.blockLength,
                            levitation: CGFloat(block.coordinate.levitation) * model.blockLength,
                            block: block
                        ) /** topTapped */ {
                            let coordinate = Coordinate(
                                row: block.coordinate.row,
                                column: block.coordinate.column,
                                levitation: block.coordinate.levitation + 1
                            )
                            model.addBlock(at: coordinate)
                        } leftTapped: {
//                            let rowOffset = model.tilt > 0 ? 1 : -1
                            let coordinate = Coordinate(
                                row: block.coordinate.row + 1,
                                column: block.coordinate.column,
                                levitation: block.coordinate.levitation
                            )
                            model.addBlock(at: coordinate)
                        } rightTapped: {
                            let columnOffset = model.tilt > 0 ? 1 : -1
                            let coordinate = Coordinate(
                                row: block.coordinate.row,
                                column: block.coordinate.column + columnOffset,
                                levitation: block.coordinate.levitation
                            )
                            model.addBlock(at: coordinate)
                        } held: {
                            model.removeBlock(at: block.coordinate)
                        }
                        .offset( /// Position the block.
                            x: CGFloat(block.coordinate.column) * model.blockLength,
                            y: CGFloat(block.coordinate.row) * model.blockLength
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .scaleEffect(y: 0.69) /// Make everything a bit squished for a perspective illusion.
    }
}
