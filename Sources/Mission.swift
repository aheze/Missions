//
//  File.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/1/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

struct Mission: Identifiable, Hashable {
    var id = UUID().uuidString
    var content: Content

    enum Content: Hashable {
        case shake(properties: ShakeMissionProperties = .init())
        case blocks(properties: BlocksMissionProperties = .init())

        var type: MissionType {
            switch self {
            case .shake:
                return .shake
            case .blocks:
                return .blocks
            }
        }
    }
}
