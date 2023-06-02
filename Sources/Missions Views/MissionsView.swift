//
//  File.swift
//  
//
//  Created by A. Zheng (github.com/aheze) on 6/1/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//
    

import SwiftUI

struct MissionsView: View {
    @Binding var path: NavigationPath
    @State var newMissionID = UUID().uuidString

    var body: some View {
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
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Missions")
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
