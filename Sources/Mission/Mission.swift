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

    @ViewBuilder static func propertiesView(mission: Binding<Mission>) -> some View {
        switch mission.wrappedValue.content {
        case .shake(let properties):
            let binding: Binding<ShakeMissionProperties> = Binding {
                properties
            } set: { newValue in
                mission.wrappedValue = .init(id: mission.wrappedValue.id, content: .shake(properties: newValue))
            }
            ShakeMissionPropertiesView(properties: binding)
        case .blocks(let properties):
            let binding: Binding<BlocksMissionProperties> = Binding {
                properties
            } set: { newValue in
                mission.wrappedValue = .init(id: mission.wrappedValue.id, content: .blocks(properties: newValue))
            }

            BlocksMissionPropertiesView(properties: binding)
        }
    }

    @ViewBuilder func missionView() -> some View {
        switch content {
        case .shake(let properties):
            ShakeMissionView(properties: properties)
        case .blocks(let properties):
            BlocksMissionView(properties: properties)
        }
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

//        @ViewBuilder func propertiesView(mission: Binding<Mission>) -> some View {
//            switch self {
//            case .shake(let properties):
//                let binding: Binding<ShakeMissionProperties> = Binding {
//                    properties
//                } set: { newValue in
//                    mission.wrappedValue = .init(id: mission.wrappedValue.id, content: .shake(properties: newValue))
//                }
//                ShakeMissionPropertiesView(properties: binding)
//            case .blocks(let properties):
//                let binding: Binding<BlocksMissionProperties> = Binding {
//                    properties
//                } set: { newValue in
//                    mission.wrappedValue = .init(id: mission.wrappedValue.id, content: .blocks(properties: newValue))
//                }
//
//                BlocksMissionPropertiesView(properties: binding)
//            }
//        }
    }

    public init(id: String = UUID().uuidString, content: Content) {
        self.id = id
        self.content = content
    }
}
