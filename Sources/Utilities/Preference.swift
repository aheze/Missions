//
//  File.swift
//  
//
//  Created by A. Zheng (github.com/aheze) on 6/2/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//
    

import SwiftUI

extension View {
    func missionPropertiesInvalidReason(reason: String?) -> some View {
        preference(key: MissionsPropertiesInvalidReasonKey.self, value: reason)
    }
}

struct MissionsPropertiesInvalidReasonKey: PreferenceKey {
    static var defaultValue: String? = nil
    static func reduce(value: inout String?, nextValue: () -> String?) { value = nextValue() }
}
