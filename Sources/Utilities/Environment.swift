//
//  Environment.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/29/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

internal struct EdgePaddingKey: EnvironmentKey {
    static let defaultValue = CGFloat(10)
}

internal struct DebugModeKey: EnvironmentKey {
    static let defaultValue = false
}

internal struct MissionCompletionKey: EnvironmentKey {
    static let defaultValue: (() -> Void)? = nil
}

internal struct MissionTimeLimitKey: EnvironmentKey {
    static let defaultValue = Double(20)
}

internal struct MissionUserInteractionOccurredKey: EnvironmentKey {
    static let defaultValue: (() -> Void)? = nil
}

internal struct MissionCompletedKey: EnvironmentKey {
    static let defaultValue = false
}

internal struct TintColorKey: EnvironmentKey {
    static let defaultValue = Color.accentColor
}

public extension EnvironmentValues {
    /// Padding to line up with the navigation title.
    var edgePadding: CGFloat {
        get { self[EdgePaddingKey.self] }
        set { self[EdgePaddingKey.self] = newValue }
    }

    var debugMode: Bool {
        get { self[DebugModeKey.self] }
        set { self[DebugModeKey.self] = newValue }
    }

    var missionCompletion: (() -> Void)? {
        get { self[MissionCompletionKey.self] }
        set { self[MissionCompletionKey.self] = newValue }
    }

    var missionTimeLimit: Double {
        get { self[MissionTimeLimitKey.self] }
        set { self[MissionTimeLimitKey.self] = newValue }
    }

    var missionUserInteractionOccurred: (() -> Void)? {
        get { self[MissionUserInteractionOccurredKey.self] }
        set { self[MissionUserInteractionOccurredKey.self] = newValue }
    }

    var missionCompleted: Bool {
        get { self[MissionCompletedKey.self] }
        set { self[MissionCompletedKey.self] = newValue }
    }
    
    var tintColor: Color {
        get { self[TintColorKey.self] }
        set { self[TintColorKey.self] = newValue }
    }
}
