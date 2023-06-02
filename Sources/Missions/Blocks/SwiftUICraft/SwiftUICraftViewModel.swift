//
//  SwiftUICraftViewModel.swift
//  SwiftUICraft
//
//  Created by A. Zheng (github.com/aheze) on 11/7/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//
    
import SwiftUI

/**
 Contains all the game logic.
 */
class SwiftUICraftViewModel: ObservableObject {
    // MARK: - Properties

    @Published var status = GameStatus.playing
    
    var level = Level.level1
    
    /// Change this to 0, 1, or 2.
    @Published var selectedLevelIndex = 2
    
    /// The current selected item in the hotbar.
    @Published var selectedItem = Item.dirt
    
    /// Corresponds to up/down/left/right controls.
    @Published var offset = CGSize.zero
    
    /// Initial Y offset of the game.
    @Published var initialYOffset = CGFloat(120)
    
    /// If liquid is animating in, the task will be stored here.
    @Published var currentLiquidAnimationTask: Task<Void, any Error>?
    
    /// Corresponds to zoom controls.
    @Published var scale = CGFloat(1)
    
    /// Whether the home indicator and other overlays are shown or not.
    @Published var homeIndicatorShown = false
    
    // MARK: - Tilting
    
    /// Saves the drag gesture's translation.
    @Published var savedTranslation = CGFloat(0)
    
    /// This will have a value when the user is dragging.
    @Published var additionalTranslation = CGFloat(0)
    
    /// The `tilt` passed to Prism for adjusting POV.
    var tilt: CGFloat {
        let translation = savedTranslation + additionalTranslation
        let tilt = 0.3 - (translation / 100)
        return tilt
//        return max(0.00001, tilt)
    }

    /// The length of each block.
    let blockLength = CGFloat(50)
    
    var blocksUpdated: (() -> Void)?
    
    init(level: Level = .level1) {
        self.level = level
    }
}

extension SwiftUICraftViewModel {
    func setBlocks(blocks: [Block], completion: (() -> Void)? = nil) {
        var blocks = blocks
        blocks = blocks.sorted { a, b in a.coordinate < b.coordinate } /// maintain order
        let inverseBlocks = blocks.sorted { a, b in a.coordinate <~ b.coordinate } /// maintain order
        
        DispatchQueue.main.async {
            self.level.world.blocks = blocks
            self.level.world.inverseBlocks = inverseBlocks
            completion?()
        }
    }
    
    /// Add the current selected item at a coordinate.
    func addBlock(at coordinate: Coordinate) {
        switch selectedItem {
        default:
            /// Only allow blocks (items that have a block preview) to be placed, not other items.
            guard let associatedBlockKind = selectedItem.associatedBlockKind else { return }
            
            var blocks = level.world.blocks
            DispatchQueue.global().async {
                /// Prevent duplicates.
                if let firstIndex = blocks.firstIndex(where: { $0.coordinate == coordinate }) {
                    blocks.remove(at: firstIndex)
                }
                let block = Block(coordinate: coordinate, blockKind: associatedBlockKind)
                blocks.append(block)
                
                self.setBlocks(blocks: blocks) {
                    self.blocksUpdated?()
                }
                
//                blocks = blocks.sorted { a, b in a.coordinate < b.coordinate } /// maintain order
//
//                DispatchQueue.main.async {
//                    self.level.world.blocks = blocks
//
//                    self.blocksUpdated?()
//                }
            }
        }
    }
}

extension SwiftUICraftViewModel {
    /// Add the current selected item at a coordinate.
    func removeBlock(at coordinate: Coordinate) {
        /// Cancel existing animations if there's any.
        currentLiquidAnimationTask?.cancel()
        currentLiquidAnimationTask = nil
        
        var blocks = level.world.blocks
        var inverseBlocks = level.world.inverseBlocks
        
        DispatchQueue.global().async {
            /// Prevent duplicates.
            if let firstIndex = blocks.firstIndex(where: { $0.coordinate == coordinate }) {
                blocks.remove(at: firstIndex)
            }
            
            if let firstIndex = inverseBlocks.firstIndex(where: { $0.coordinate == coordinate }) {
                inverseBlocks.remove(at: firstIndex)
            }
            
            DispatchQueue.main.async {
                self.level.world.blocks = blocks
                self.level.world.inverseBlocks = inverseBlocks
                
                self.blocksUpdated?()
            }
        }
    }
}
