//
//  File.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/2/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import CodeScanner
import SwiftUI

// MARK: - Mission view

struct CodeMissionView: View {
    @Environment(\.debugMode) var debugMode
    @Environment(\.missionCompletion) var missionCompletion
    @Environment(\.missionUserInteractionOccurred) var missionUserInteractionOccurred

    var properties: CodeMissionProperties

    var body: some View {
        VStack {
            CodeScanner { result in
            }
//            Text("Code")
//            if debugMode {
//                Button("Debug testing button") {}
//            }
        }
    }
}
