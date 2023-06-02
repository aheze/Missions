//
//  ContentView.swift
//  MissionsExample
//
//  Created by A. Zheng (github.com/aheze) on 6/1/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import Missions
import SwiftUI

enum MissionViewKind: CaseIterable {
    case alarmEditor
    case alarmPreview

    var title: String {
        switch self {
        case .alarmEditor:
            return "Alarm Editor"
        case .alarmPreview:
            return "Alarm Preview"
        }
    }
}

struct ContentView: View {
    @State var selectedKind = MissionViewKind.alarmEditor
    @State var selectedMissions: [Mission] = [
        .init(content: .blocks())
    ]

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                switch selectedKind {
                case .alarmEditor:
                    AlarmEditorBase(selectedMissions: $selectedMissions)
                case .alarmPreview:
                    AlarmViewBase(missions: selectedMissions)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Picker("Selected View", selection: $selectedKind) {
                ForEach(MissionViewKind.allCases, id: \.self) { kind in
                    Text(kind.title)
                        .tag(kind)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .background(.regularMaterial)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
