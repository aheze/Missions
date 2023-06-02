//
//  File.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/1/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

public enum MissionType: CaseIterable {
    case shake
    case blocks

    public var defaultMissionContent: Mission.Content {
        switch self {
        case .shake:
            return .shake()
        case .blocks:
            return .blocks()
        }
    }

    public var metadata: Metadata {
        switch self {
        case .shake:
            return Metadata(
                icon: "iphone.radiowaves.left.and.right",
                title: "Shake",
                description: "Shake your phone"
            )
        case .blocks:
            return Metadata(
                icon: "cube",
                title: "Blocks",
                description: "Craft with blocks"
            )
        }
    }
}

extension MissionType: Identifiable {
    public var id: Self {
        self
    }

    public struct Metadata {
        public var icon: String
        public var title: String
        public var description: String
    }
}
