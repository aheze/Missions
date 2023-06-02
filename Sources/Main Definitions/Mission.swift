//
//  File.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/1/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

/**
 Adding a new mission? Start here.

 Fill in the placeholders with your mission name - e.g. "puzzle".
 */
public enum MissionType: Codable, CaseIterable {
    case shake
    case blocks
    case code
//    case <#yourMissionName#>

    public var defaultMissionContent: Mission.Content {
        switch self {
        case .shake:
            return .shake()
        case .blocks:
            return .blocks()
        case .code:
            return .code()
//        case .<#yourMissionName#>:
//            return .<#yourMissionName#>()
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
        case .code:
            return Metadata(
                icon: "qrcode",
                title: "Code Scan",
                description: "Scan a QR code or barcode"
            )
//        case .<#yourMissionName#>:
//            return Metadata(
//                icon: "<#your.mission.icon#>",
//                title: "<#YourMissionName#>",
//                description: "<#Your mission description#>"
//            )
        }
    }
}

public struct Mission: Codable, Identifiable, Hashable {
    public enum Content: Codable, Hashable {
        case shake(properties: ShakeMissionProperties = .init())
        case blocks(properties: BlocksMissionProperties = .init())
        case code(properties: CodeMissionProperties = .init())
//        case <#yourMissionName#>(properties: <#YourMissionName#>MissionProperties = .init())

        public var type: MissionType {
            switch self {
            case .shake:
                return .shake
            case .blocks:
                return .blocks
            case .code:
                return .code
//            case .<#yourMissionName#>:
//                return .<#yourMissionName#>
            }
        }
    }

    @ViewBuilder static func propertiesView(mission: Binding<Mission>) -> some View {
        switch mission.wrappedValue.content {
        case .shake(let properties):
            let binding = Binding {
                properties
            } set: { newValue in
                mission.updateContent(content: .shake(properties: newValue))
            }

            ShakeMissionPropertiesView(properties: binding)
        case .blocks(let properties):
            let binding = Binding {
                properties
            } set: { newValue in
                mission.updateContent(content: .blocks(properties: newValue))
            }

            BlocksMissionPropertiesView(properties: binding)
        case .code(let properties):
            let binding = Binding {
                properties
            } set: { newValue in
                mission.updateContent(content: .code(properties: newValue))
            }

            CodeMissionPropertiesView(properties: binding)
//        case .<#yourMissionName#>(let properties):
//            let binding = Binding {
//                properties
//            } set: { newValue in
//                mission.updateContent(content: .<#yourMissionName#>(properties: newValue))
//            }
//            <#YourMissionName#>MissionPropertiesView(properties: binding)
        }
    }

    @ViewBuilder func missionView() -> some View {
        switch content {
        case .shake(let properties):
            ShakeMissionView(properties: properties)
        case .blocks(let properties):
            BlocksMissionView(properties: properties)
        case .code(let properties):
            CodeMissionView(properties: properties)
//        case .<#yourMissionName#>(let properties):
//            <#YourMissionName#>MissionView(properties: properties)
        }
    }

    // MARK: - End customization code

    // MARK: - Boilerplate code

    public var id = UUID().uuidString
    public var content: Content
    public init(id: String = UUID().uuidString, content: Content) {
        self.id = id
        self.content = content
    }
}

// MARK: - More boilerplate code

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

extension Binding where Value == Mission {
    func updateContent(content: Mission.Content) {
        wrappedValue = .init(id: wrappedValue.id, content: content)
    }
}
