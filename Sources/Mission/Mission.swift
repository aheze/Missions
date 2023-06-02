//
//  File.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/1/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

public struct Mission: Identifiable, Hashable {
    public var id = UUID().uuidString
    public var content: Content

    public init(id: String = UUID().uuidString, content: Content) {
        self.id = id
        self.content = content
    }

    public enum Content: Hashable {
        case shake(properties: ShakeMissionProperties = .init())
        case blocks(properties: BlocksMissionProperties = .init())

        public var type: MissionType {
            switch self {
            case .shake:
                return .shake
            case .blocks:
                return .blocks
            }
        }
    }
}
