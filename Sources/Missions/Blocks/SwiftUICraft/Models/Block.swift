//
//  Block.swift
//  SwiftUICraft
//
//  Created by A. Zheng (github.com/aheze) on 11/9/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//
    
import SwiftUI

/// A block chunk in the world.
struct Block: Equatable, Codable, Hashable {
    var coordinate: Coordinate
    var blockKind: BlockKind
    
    /**
     Multiply the extrusion by this.
     
     Used for extending a block's height past a cube, for liquids and lasers.
     */
    var extrusionMultiplier = CGFloat(1)
    
    /// If the block is shown. For liquids, this will initially be `false`.
    var active = true
    
    /// How long you should hold a block to break it.
    static let holdDurationForRemoval = CGFloat(0.5)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate)
        hasher.combine(blockKind)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.coordinate == rhs.coordinate && lhs.blockKind == rhs.blockKind
    }

}

/// Enumerates all possible block types.
enum BlockKind: String, Codable, CaseIterable {
    case dirt
    case grass
    case log
    case stone
    case leaf
    
    case ice
    case concrete
    case blackstone
    case clay
    case sand
    case spruceLog
    case sprucePlanks
    case amethyst
    case cactus
    
    case crimsonStem
    case warpedStem
    case nylium
    case guildedBlackstone
    case glowstone
    case netherBricks
    case netherrack
    case gold
    case laser
    
    case diamond
    
    var texture: Texture {
        switch self {
        case .dirt:
            return .image("dirt")
        case .grass:
            return .differentSides(top: "grass_block_top", sides: "grass_block_side")
        case .log:
            return .differentSides(top: "oak_log_top", sides: "oak_log")
        case .stone:
            return .image("stone")
        case .leaf:
            return .image("oak_leaves")
        case .ice:
            return .image("blue_ice")
        case .concrete:
            return .image("cyan_concrete_powder")
        case .blackstone:
            return .differentSides(top: "blackstone_top", sides: "blackstone")
        case .clay:
            return .image("clay")
        case .sand:
            return .image("sand")
        case .spruceLog:
            return .differentSides(top: "spruce_log_top", sides: "spruce_log")
        case .sprucePlanks:
            return .image("spruce_planks")
        case .amethyst:
            return .image("amethyst_block")
        case .cactus:
            return .differentSides(top: "cactus_top", sides: "cactus_side")
        case .crimsonStem:
            return .differentSides(top: "crimson_stem_top", sides: "crimson_stem")
        case .warpedStem:
            return .differentSides(top: "warped_stem_top", sides: "warped_stem")
        case .nylium:
            return .differentSides(top: "warped_nylium", sides: "warped_nylium_side")
        case .guildedBlackstone:
            return .image("gilded_blackstone")
        case .glowstone:
            return .image("glowstone")
        case .netherBricks:
            return .image("nether_bricks")
        case .netherrack:
            return .image("netherrack")
        case .gold:
            return .image("gold_block")
        case .laser:
            return .laser
        case .diamond:
            return .image("diamond_block")
        }
    }
    
    var associatedItem: Item? {
        switch self {
        case .dirt:
            return .dirt
        case .grass:
            return .grass
        case .log:
            return .log
        case .stone:
            return .stone
        case .leaf:
            return .leaf
        case .ice:
            return .ice
        case .concrete:
            return .concrete
        case .blackstone:
            return .blackstone
        case .clay:
            return .clay
        case .sand:
            return .sand
        case .spruceLog:
            return .spruceLog
        case .sprucePlanks:
            return .sprucePlanks
        case .amethyst:
            return .amethyst
        case .cactus:
            return .cactus
        case .crimsonStem:
            return .crimsonStem
        case .warpedStem:
            return .warpedStem
        case .nylium:
            return .nylium
        case .guildedBlackstone:
            return .guildedBlackstone
        case .glowstone:
            return .glowstone
        case .netherBricks:
            return .netherBricks
        case .netherrack:
            return .netherrack
        case .gold:
            return .gold
        case .laser:
            return .laser
        case .diamond:
            return .diamond
        }
    }
}
