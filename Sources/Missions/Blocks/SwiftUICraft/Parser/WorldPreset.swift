//
//  WorldPreset.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/31/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

struct WorldPreset: Identifiable {
    var id: String {
        name
    }

    var name: String
    var world: World

    static var allPresets: [WorldPreset] = {
        let strings = WorldParser.getPresetStrings()

        let presets = strings.compactMap { WorldParser.getPreset(string: $0) }
        return presets
    }()
}

extension WorldParser {
    static func getPreset(string: String) -> WorldPreset? {
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let components = string.components(separatedBy: "\n")

        if let name = components.first {
            let worldString = components.dropFirst().joined(separator: "\n")

            let world = process(string: worldString)

            return WorldPreset(name: name, world: world)
        }

        return nil
    }

    static func getPresetStrings() -> [String] {
        /// presets string is split by ---
        /// stored in a local file right now, will host online later
        guard let string = getWorldPresetsString() else { return [] }

        var components = string.components(separatedBy: "---")
        components = components.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        return components
    }
}

extension WorldParser {
    static func getWorldPresetsString() -> String? {
        
        let url = Bundle.module.url(forResource: "WorldPresets", withExtension: "txt")

        guard let url else {
            print("Couldn't locate WorldPresets file.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)

            guard let string = String(data: data, encoding: .utf8) else {
                print("Couldn't create string from world presets.")
                return nil
            }

            return string

        } catch {
            print("Couldn't read data: \(error)")
        }

        return nil
    }
}
