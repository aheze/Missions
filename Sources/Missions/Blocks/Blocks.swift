//
//  Blocks.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/29/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

// MARK: - Mission properties

public struct BlocksMissionProperties: Codable, Hashable {
    /// the name of the preset
    public var selectedPresetName: String?

    /// nil if using a default preset. If imported from the server, the preset data will be here.
    public var selectedPresetString: String?

    public init(selectedPresetName: String? = nil, selectedPresetString: String? = nil) {
        self.selectedPresetName = selectedPresetName
        self.selectedPresetString = selectedPresetString
    }
}

extension String {
    func getImportedWorldName() -> String? {
        let worldString = trimmingCharacters(in: .whitespacesAndNewlines)
        let components = worldString.components(separatedBy: "\n")

        if let title = components.first {
            return title
        }

        return nil
    }
}
