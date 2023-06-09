//
//  File.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/1/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

public struct MissionsView: View {
    @Binding public var path: NavigationPath

    public init(path: Binding<NavigationPath>) {
        self._path = path
    }

    public var body: some View {
        ScrollView {
            VStack {
                MissionsGridView { type in
                    path.append(type)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 20)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Don't see your favorite mission? [Request it!](https://github.com/aheze/Missions/issues/new/choose)")
                    .font(.headline)

                Text("All missions are free and open source on [GitHub](https://github.com/aheze/Missions).")
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .dynamicVerticalPadding()
            .dynamicHorizontalPadding()
            .background(.regularMaterial)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Add Mission")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MissionsViewPreview: View {
    @State var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            MissionsView(path: $path)
        }
    }
}

struct MissionsViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        MissionsViewPreview()
    }
}
