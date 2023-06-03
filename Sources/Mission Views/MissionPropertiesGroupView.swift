//
//  MissionPropertiesGroupView.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/30/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

struct MissionPropertiesGroupView<Content: View>: View {
    @Environment(\.edgePadding) var edgePadding

    var header: String
    var footer: String? = nil
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(header)
                .foregroundColor(.secondary)
                .font(.subheadline)
                .textCase(.uppercase)

            content
                .groupedBackground()
            
            if let footer {
                Text(footer)
                    .foregroundColor(.secondary)
                    .font(.callout)
            }
        }
    }
}
