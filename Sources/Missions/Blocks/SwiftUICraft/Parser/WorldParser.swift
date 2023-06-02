//
//  WorldParser.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/30/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

enum WorldParser {
    /// process a world string, example:
    /*
     treasure
     3x3

     gold diamond gold
     diamond gold diamond
     gold diamond gold
     */
    static func process(string: String) -> World {
        var world = World(width: 1, height: 1, blocks: [])

        var string = string
        string = string.condenseSpaces()
        string = string.condenseDoubleNewlines()

        let components = string.components(separatedBy: "\n\n")

        // MARK: - Get width and height

        if var first = components.first {
            first = first.trimmingCharacters(in: .whitespacesAndNewlines)
            let characters = first.components(separatedBy: "x")

            if let string = characters.first, let width = Int(string) {
                world.width = width
            }

            if let string = characters.last, let height = Int(string) {
                world.height = height
            }
        }

        let layers = Array(components.dropFirst().reversed())

        for layerIndex in layers.indices {
            let layer = layers[layerIndex]

            let rows = layer.components(separatedBy: "\n")

            for rowIndex in rows.indices {
                var row = rows[rowIndex]
                row = row.trimmingCharacters(in: .whitespacesAndNewlines)

                let columns = row.components(separatedBy: " ")

                for columnIndex in columns.indices {
                    let column = columns[columnIndex]

                    if let blockKind = BlockKind(rawValue: column) {
                        let coordinate = Coordinate(row: rowIndex, column: columnIndex, levitation: layerIndex)

                        let block = Block(coordinate: coordinate, blockKind: blockKind)
                        world.blocks.append(block)
                    }
                }
            }
        }

        return world
    }
}

extension String {
    func condenseSpaces() -> String {
        return replacingOccurrences(of: #"[\h\t]{2,}"#, with: " ", options: .regularExpression, range: nil)
    }

    func condenseDoubleNewlines() -> String {
        return replacingOccurrences(of: #"\n{2,}"#, with: "\n\n", options: .regularExpression, range: nil)
    }
}

extension WorldParser {
    static let torch = """
    3x3

    x x x
    x glowstone x
    x x x

    x x x
    x log x
    x x x

    x x x
    x log x
    x x x

    x x x
    x log x
    x x x
    """

    static let treasure = """
    3x3

    gold diamond gold
    diamond gold diamond
    gold diamond gold
    """

    static let turf = """
    3x3

    grass grass grass
    grass x x
    grass x x

    dirt dirt dirt
    dirt x x
    dirt x x
    """

    static let iceFrame = """
    4x4

    ice ice ice ice
    ice x x ice
    ice x x ice
    ice ice ice ice

    ice x x ice
    x x x x
    x x x x
    ice x x ice

    ice x x ice
    x x x x
    x x x x
    ice x x ice
    """

    static let desert = """
    5x5

    x x x x x
    x x x cactus x
    x x x x x
    x x x x x
    x x x x x

    x x x x x
    x x x cactus x
    x x x x x
    x cactus x x x
    x x x x x

    sand sand sand sand sand
    sand sand sand sand sand
    sand sand sand sand sand
    sand sand sand sand sand
    sand sand sand sand sand
    """

    static let stoneAndLeaf = """
    5x5

    x x x x x
    x leaf x leaf x
    x x x x x
    x leaf x leaf x
    x x x x x

    x x x x x
    x leaf x leaf x
    x x x x x
    x leaf x leaf x
    x x x x x

    concrete stone concrete stone concrete
    stone leaf x leaf stone
    concrete x x x concrete
    stone leaf x leaf stone
    concrete stone concrete stone concrete
    """

    static let tree = """
    3x3

    x leaf x
    leaf leaf leaf
    x leaf x

    leaf leaf leaf
    leaf log leaf
    leaf leaf leaf

    x x x
    x log x
    x x x

    x x x
    x log x
    x x x

    x x x
    x log x
    x x x


    grass grass grass
    grass grass grass
    grass grass grass
    """

    static let statue = """
    3x3

    x x x
    x leaf x
    x x x

    x x x
    x log x
    x x x

    x x x
    x log x
    x x x

    x x x
    x log x
    log x log


    grass grass grass
    grass grass grass
    grass grass grass
    """
}

// case dirt
// case grass
// case log
// case stone
// case leaf
//
// case ice
// case concrete
// case blackstone
// case clay
// case sand
// case spruceLog
// case sprucePlanks
// case amethyst
// case cactus
//
// case crimsonStem
// case warpedStem
// case nylium
// case guildedBlackstone
// case glowstone
// case netherBricks
// case netherrack
// case gold
// case laser

/// For testing
struct WorldParserView: View {
    let string = """
    3x3

    x x x
    x leaf x
    x x x

    x x x
    x log x
    x x x

    x x x
    x log x
    x x x

    x x x
    x log x
    log x log


    grass grass grass
    grass grass grass
    grass grass grass
    """

    @StateObject var model = SwiftUICraftViewModel()

    var body: some View {
        VStack {
            GameView(model: model)

            Button("Process") {
                process()
            }
        }
        .onAppear {
            process()
        }
    }

    func process() {
        let world = WorldParser.process(string: string)
        let level = Level(world: world, items: [.grass, .dirt], background: [])
        model.level = level
        model.objectWillChange.send()
    }
}

struct WorldParserView_Previews: PreviewProvider {
    static var previews: some View {
        WorldParserView()
    }
}
