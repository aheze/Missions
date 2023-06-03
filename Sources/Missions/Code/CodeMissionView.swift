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

    @State var scannedWrongCodeString: String?
    @State var error: Error?

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Scan your code.")
                    .font(.headline)

                Text(properties.codeString ?? "Mission wasn't set up correctly.")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .dynamicVerticalPadding()
            .dynamicHorizontalPadding()
            .background {
                Rectangle()
                    .fill(.regularMaterial)
            }

            if properties.codeString == nil {
                Button("Finish Mission") {
                    missionCompletion?()
                }
            }

            CodeScanner { result in
                missionUserInteractionOccurred?()
                
                switch result {
                case .success(let result):
                    if result.string == properties.codeString {
                        missionCompletion?()
                    } else {
                        scannedWrongCodeString = result.string
                    }
                case .failure(let error):
                    print("Error scanning code: \(error)")
                    self.error = error
                }
            }
        }
        .errorAlert(error: $error)
        .alert("Did you scan the right code?", isPresented: Binding {
            scannedWrongCodeString != nil
        } set: { _ in
            scannedWrongCodeString = nil
        }) {
            Button("Yes, Finish Mission") {
                scannedWrongCodeString = nil
                missionCompletion?()
            }

            Button("Try Again") {
                scannedWrongCodeString = nil
            }
        } message: {
            Text("The scanned code '\(scannedWrongCodeString ?? "")' doesn't match '\(properties.codeString ?? "")'.")
        }
    }
}
