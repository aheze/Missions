//
//  Level.swift
//  SwiftUICraft
//
//  Created by A. Zheng (github.com/aheze) on 11/7/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//
    
import SwiftUI

/**
 A saved world along with hotbar items and a gradient background.
 */
struct Level: Codable {
    var world: World
    var items: [Item]
    var background: [Int]
}

extension Level {
    /// The default overworld.
    static let level1: Level = {
        let world: World = {
            let width = 15
            let height = 6
            var blocks = [Block]()
            
            /// base dirt layer
            for row in 0..<height {
                for column in 0..<width {
                    let shouldBeDirt = (column - (height - row)) < 3
                    
                    let coordinate = Coordinate(row: row, column: column, levitation: 0)
                    let block = Block(coordinate: coordinate, blockKind: shouldBeDirt ? .dirt : .grass)
                    blocks.append(block)
                }
            }
            
            /// jagged shape
            for row in 0..<height {
                for column in 0..<10 {
                    let shouldAdd = (column - (height - row)) < 3
                    
                    if shouldAdd {
                        let coordinate = Coordinate(row: row, column: column, levitation: 1)
                        let block = Block(coordinate: coordinate, blockKind: .dirt)
                        blocks.append(block)
                    }
                }
            }
            
            /// jagged shape
            for row in 0..<height {
                for column in 0..<10 {
                    let shouldAdd = (column - (height - row)) < 0
                    
                    if shouldAdd {
                        let coordinate = Coordinate(row: row, column: column, levitation: 2)
                        let block = Block(coordinate: coordinate, blockKind: .grass)
                        blocks.append(block)
                    }
                }
            }
            
            /// fill in some more grass blocks at the bottom
            for (x, y) in [(2, 4), (1, 5), (2, 5), (3, 5)] {
                let coordinate = Coordinate(row: y, column: x, levitation: 2)
                let block = Block(coordinate: coordinate, blockKind: .grass)
                blocks.append(block)
            }
            
            /// tree
            let trunk = (11, 2)
            for levitation in 1..<8 {
                switch levitation {
                case 5:
                    /// first layer leaves
                    for (x, y) in [(-1, -1), (0, -1), (1, -1)] {
                        let coordinate = Coordinate(row: trunk.1 + y, column: trunk.0 + x, levitation: levitation)
                        let block = Block(coordinate: coordinate, blockKind: .leaf)
                        blocks.append(block)
                    }
                    
                    let coordinateLeft = Coordinate(row: trunk.1, column: trunk.0 - 1, levitation: levitation)
                    let blockLeft = Block(coordinate: coordinateLeft, blockKind: .leaf)
                    blocks.append(blockLeft)
                    
                    let coordinate = Coordinate(row: trunk.1, column: trunk.0, levitation: levitation)
                    let block = Block(coordinate: coordinate, blockKind: .log)
                    blocks.append(block)
                    
                    let coordinateRight = Coordinate(row: trunk.1, column: trunk.0 + 1, levitation: levitation)
                    let blockRight = Block(coordinate: coordinateRight, blockKind: .leaf)
                    blocks.append(blockRight)
                    
                    /// bottom leaves
                    for (x, y) in [(-1, 1), (0, 1), (1, 1)] {
                        let coordinate = Coordinate(row: trunk.1 + y, column: trunk.0 + x, levitation: levitation)
                        let block = Block(coordinate: coordinate, blockKind: .leaf)
                        blocks.append(block)
                    }
                case 6:
                    /// second layer of leaves, in cross shape
                    for (x, y) in [(0, -1), (-1, 0), (0, 0), (1, 0), (0, 1)] {
                        let coordinateRight = Coordinate(row: trunk.1 + y, column: trunk.0 + x, levitation: levitation)
                        let block = Block(coordinate: coordinateRight, blockKind: .leaf)
                        blocks.append(block)
                    }
                case 7:
                    /// top leaf block
                    let coordinate = Coordinate(row: trunk.1, column: trunk.0, levitation: levitation)
                    let block = Block(coordinate: coordinate, blockKind: .leaf)
                    blocks.append(block)
                default:
                    /// just a log
                    let coordinate = Coordinate(row: trunk.1, column: trunk.0, levitation: levitation)
                    let block = Block(coordinate: coordinate, blockKind: .log)
                    blocks.append(block)
                }
            }
            
            blocks = blocks.sorted { a, b in a.coordinate < b.coordinate } /// maintain order
            let world = World(width: width, height: height, blocks: blocks)
            return world
        }()
        
        let level = Level(
            world: world,
            items: [
                .dirt,
                .grass,
                .log,
                .stone,
                .leaf,
                .pick,
                .sword,
                .beef,
            ],
            background: [0x56B1DB, 0xFFFFFF, 0xFFFFFF, 0x96C9FD]
        )
        
        return level
    }()
}

extension Level {
    /// Sand / ice world.
    static let level2: Level = {
        let world: World = {
            let width = 10
            let height = 6
            var blocks = [Block]()
            
            for row in 0..<height {
                for column in 0..<width {
                    let coordinate = Coordinate(row: row, column: column, levitation: 0)
                    let block = Block(coordinate: coordinate, blockKind: .clay)
                    blocks.append(block)
                }
            }
            
            /// jagged shape
            for row in 0..<height {
                for column in 0..<10 {
                    let shouldAdd = (column - (height - row)) < -2
                    
                    if shouldAdd {
                        let coordinate = Coordinate(row: row, column: column, levitation: 1)
                        let block = Block(coordinate: coordinate, blockKind: .sand)
                        blocks.append(block)
                    }
                }
            }
            
            /// fill in some more sand blocks at the bottom
            for (x, y) in [(0, 4), (0, 5), (1, 3), (1, 4), (1, 5), (2, 4), (2, 5)] {
                let coordinate = Coordinate(row: y, column: x, levitation: 1)
                let block = Block(coordinate: coordinate, blockKind: .grass)
                blocks.append(block)
            }
            
            for (x, y) in [
                (4, 0), (5, 0), (6, 0), (7, 0),
                (9, 0), (9, 1), (9, 2), (9, 3), (9, 4),
                (8, 0), (8, 1), (8, 2), (8, 3),
                (7, 0), (7, 1), (7, 2),
            ] {
                let coordinate = Coordinate(row: y, column: x, levitation: 1)
                let block = Block(coordinate: coordinate, blockKind: .blackstone)
                blocks.append(block)
            }

            for (x, y) in [
                (9, 0), (9, 1), (9, 2),
                (8, 0), (8, 1),
                (7, 0),
            ] {
                let coordinate = Coordinate(row: y, column: x, levitation: 2)
                let block = Block(coordinate: coordinate, blockKind: .blackstone)
                blocks.append(block)
            }
            
            _ = {
                let coordinate = Coordinate(row: 0, column: 9, levitation: 3)
                let block = Block(coordinate: coordinate, blockKind: .amethyst)
                blocks.append(block)
            }()
            
            _ = {
                let coordinate = Coordinate(row: 0, column: 3, levitation: 2)
                let block = Block(coordinate: coordinate, blockKind: .amethyst)
                blocks.append(block)
            }()
            
            for (x, y, z) in [
                (1, 0, 2), (0, 2, 2),
                (0, 2, 3),
            ] {
                let coordinate = Coordinate(row: y, column: x, levitation: z)
                let block = Block(coordinate: coordinate, blockKind: .cactus)
                blocks.append(block)
            }
            
            for (x, y, z) in [
                (5, 4, 1), (5, 4, 2), (5, 4, 3),
            ] {
                let coordinate = Coordinate(row: y, column: x, levitation: z)
                let block = Block(coordinate: coordinate, blockKind: .spruceLog)
                blocks.append(block)
            }
            
            _ = {
                let coordinate = Coordinate(row: 4, column: 5, levitation: 4)
                let block = Block(coordinate: coordinate, blockKind: .sprucePlanks)
                blocks.append(block)
            }()
            
            for (x, y) in [
                (3, 1), (2, 2), (2, 3),
            ] {
                let coordinate = Coordinate(row: y, column: x, levitation: 1)
                let block = Block(coordinate: coordinate, blockKind: .ice)
                blocks.append(block)
            }
            
            blocks = blocks.sorted { a, b in a.coordinate < b.coordinate } /// maintain order
            let world = World(width: width, height: height, blocks: blocks)
            return world
        }()
        
        let level = Level(
            world: world,
            items: [
                .ice,
                .concrete,
                .blackstone,
                .clay,
                .sand,
                .spruceLog,
                .sprucePlanks,
                .amethyst,
            ],
            background: [0x4CCCDA, 0xFFFFFF, 0xFFFFFF, 0x8BDAC4]
        )
        
        return level
    }()
}

extension Level {
    /// The nether!
    static let level3: Level = {
        let world: World = {
            let width = 12
            let height = 8
            var blocks = [Block]()
            
            for row in 0..<height {
                for column in 0..<width {
                    let coordinate = Coordinate(row: row, column: column, levitation: 0)
                    let block = Block(coordinate: coordinate, blockKind: .netherrack)
                    blocks.append(block)
                }
            }
            
            /// jagged shape
            for row in 0..<height {
                for column in 0..<10 {
                    let shouldAdd = (column - (height - row)) < -2
                    
                    if shouldAdd {
                        let coordinate = Coordinate(row: row, column: column, levitation: 1)
                        let block = Block(coordinate: coordinate, blockKind: .netherrack)
                        blocks.append(block)
                    }
                }
            }
            
            for row in 0..<height {
                for column in 0..<10 {
                    let shouldAdd = (column - (height - row)) < -5
                    
                    if shouldAdd {
                        let coordinate = Coordinate(row: row, column: column, levitation: 2)
                        let block = Block(coordinate: coordinate, blockKind: .nylium)
                        blocks.append(block)
                    }
                }
            }
            
            /// right side
            for row in 0..<height {
                for column in 0..<width {
                    let shouldAdd = (column - (height - row)) < -3
                    
                    if shouldAdd {
                        let coordinate = Coordinate(row: height - row - 1, column: width - column - 1, levitation: 1)
                        let block = Block(coordinate: coordinate, blockKind: .nylium)
                        blocks.append(block)
                    }
                }
            }
            
            for row in 0..<height {
                for column in 0..<width {
                    let shouldAdd = (column - (height - row)) < -5
                    
                    if shouldAdd {
                        let coordinate = Coordinate(row: height - row - 1, column: width - column - 1, levitation: 2)
                        let block = Block(coordinate: coordinate, blockKind: .blackstone)
                        blocks.append(block)
                    }
                }
            }
            
            for (x, y) in [
                (11, 1), (11, 2), (10, 2), (10, 3), (9, 4)
            ] {
                let coordinate = Coordinate(row: y, column: x, levitation: 1)
                let block = Block(coordinate: coordinate, blockKind: .nylium)
                blocks.append(block)
            }
            
            for x in [
                7, 9, 11
            ] {
                for y in 1 ... 4 {
                    let coordinate = Coordinate(row: 0, column: x, levitation: y)
                    let block = Block(coordinate: coordinate, blockKind: .netherBricks)
                    blocks.append(block)
                }
                
                let coordinate = Coordinate(row: 0, column: x, levitation: 5)
                let block = Block(coordinate: coordinate, blockKind: .glowstone)
                blocks.append(block)
            }
            
            for (x, y) in [
                (6, 0), (8, 0), (10, 0),
                (7, 1), (8, 1), (9, 1), (10, 1),
                (9, 2), (9, 3)
            ] {
                let coordinate = Coordinate(row: y, column: x, levitation: 1)
                let block = Block(coordinate: coordinate, blockKind: .guildedBlackstone)
                blocks.append(block)
            }
            
            for y in 1 ... 5 {
                let coordinate = Coordinate(row: 3, column: 6, levitation: y)
                let block = Block(coordinate: coordinate, blockKind: .warpedStem)
                blocks.append(block)
            }
            
            for y in 1 ... 3 {
                let coordinate = Coordinate(row: 5, column: 3, levitation: y)
                let block = Block(coordinate: coordinate, blockKind: .crimsonStem)
                blocks.append(block)
            }
            
            for (x, y) in [
                (8, 0), (10, 0)
            ] {
                let coordinate = Coordinate(row: y, column: x, levitation: 2)
                let block = Block(coordinate: coordinate, blockKind: .gold)
                blocks.append(block)
            }
            
            blocks = blocks.sorted { a, b in a.coordinate < b.coordinate } /// maintain order
            let world = World(width: width, height: height, blocks: blocks)
            return world
        }()
        
        let level = Level(
            world: world,
            items: [
                .warpedStem,
                .nylium,
                .guildedBlackstone,
                .glowstone,
                .netherBricks,
                .netherrack,
                .gold,
                .laser,
            ],
            background: [0x6B1500, 0x8E0003, 0x500002, 0x000000]
        )
        
        return level
    }()
}
