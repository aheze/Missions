//
//  World.swift
//  SwiftUICraft
//
//  Created by A. Zheng (github.com/aheze) on 11/9/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

/// Each world has a set size and stores which blocks are placed.
struct World: Equatable, Codable {
    var width: Int
    var height: Int
    var blocks: [Block]
    var inverseBlocks = [Block]()

    func getContainingBlockKinds() -> [BlockKind] {
        let kinds = blocks.map { $0.blockKind }.uniqued()
        return kinds
    }
    
    /// the height/levitation of the structure
    func getBlocksMaximumLevitation() -> Int {
        let max = blocks.map { $0.coordinate }.max { a, b in a.levitation < b.levitation }
        return max?.levitation ?? 0
    }
}
