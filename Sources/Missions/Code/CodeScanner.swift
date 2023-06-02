//
//  CodeScanner.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/2/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import CodeScanner
import SwiftUI

struct CodeScanner: View {
    var completed: (Result<ScanResult, ScanError>) -> Void
    
    var body: some View {
        CodeScannerView(codeTypes: [.code128, .ean13, .upce, .code39, .qr, .microQR]) { result in
            print("Result: \(result)")
            completed(result)
        }
        .ignoresSafeArea()
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white, lineWidth: 4)
                .shadow(
                    color: Color.black.opacity(0.25),
                    radius: 16,
                    x: 0,
                    y: 10
                )
                .frame(maxWidth: 300, maxHeight: 180)
                .dynamicHorizontalPadding()
                .dynamicHorizontalPadding()
        }
    }
}

struct SetupCodeScanner: View {
    var completed: (Result<ScanResult, ScanError>) -> Void

    var body: some View {
        NavigationStack {
            Color.clear
                .overlay(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Scan a barcode or QR code.")
                            .font(.headline)

                        Text("Look for a cereal box or something.")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .dynamicVerticalPadding()
                    .dynamicHorizontalPadding()
                    .background {
                        Rectangle()
                            .fill(.regularMaterial)
                    }
                }
                .background {
                    VStack {
                        Divider()

                        CodeScanner(completed: completed)
                    }
                }
                .navigationTitle("Scan Code")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarCloseButton()
        }
    }
}
