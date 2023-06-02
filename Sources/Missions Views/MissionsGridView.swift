//
//  File.swift
//  
//
//  Created by A. Zheng (github.com/aheze) on 6/1/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//
    

import SwiftUI

struct MissionsGridView: View {
    var pressedType: (MissionType) -> Void

    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 200), spacing: 8)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(MissionType.allCases) { type in
                MissionsGridCell(type: type) {
                    pressedType(type)
                }
            }
        }
    }
}

struct MissionsGridCell: View {
    var type: MissionType
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            content
        }
    }

    @ViewBuilder var content: some View {
        let metadata = type.metadata

        VStack(alignment: .leading, spacing: 24) {
            Image(systemName: metadata.icon)
                .font(.title3)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            Text(metadata.title)
                .font(.title2)
                .minimumScaleFactor(0.8)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .mask {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
        }
    }
}

struct MissionsGridView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                MissionsGridView { _ in
                    
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 20)
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

