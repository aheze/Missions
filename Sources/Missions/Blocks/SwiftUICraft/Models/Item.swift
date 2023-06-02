//
//  Item.swift
//  SwiftUICraft
//
//  Created by A. Zheng (github.com/aheze) on 11/9/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//
    
import SwiftUI

/// A hotbar item.
enum Item: String, Codable, CaseIterable {
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
    
    case pick
    case sword
    case beef
    
    enum Preview {
        case image(String)
        case blockView(BlockView)
    }
    
    var preview: Preview {
        switch self {
        case .pick:
            return .image("diamond_pickaxe")
        case .sword:
            return .image("diamond_sword")
        case .beef:
            return .image("cooked_beef")
        case .laser:
            return .image("laser")
        default:
            if let associatedBlockKind {
                return .blockView(
                    BlockView(
                        tilt: 1,
                        length: 20,
                        levitation: 0,
                        block: Block(
                            coordinate: .init( /// coordinate is ignored
                                row: 0,
                                column: 0,
                                levitation: 0
                            ),
                            blockKind: associatedBlockKind
                        )
                    )
                )
            }
        }
        
        fatalError("No preview for \(self).")
    }
    
    var associatedBlockKind: BlockKind? {
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
        case .pick:
            return nil
        case .sword:
            return nil
        case .beef:
            return nil
        }
    }
}
