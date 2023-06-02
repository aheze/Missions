//
//  MissionPropertiesView.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/29/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

public struct MissionPropertiesView: View {
    @State var editingMission: Mission
    var type: MissionType
    var isEditingExistingMission: Bool
    var goToMissionPreview: (Mission) -> Void
    var missionFinishedEditing: (Mission) -> Void
    @State var propertiesModified = false

    public init(
        editingMission: Mission,
        type: MissionType,
        isEditingExistingMission: Bool,
        goToMissionPreview: @escaping (Mission) -> Void,
        missionFinishedEditing: @escaping (Mission) -> Void
    ) {
        self._editingMission = State(initialValue: editingMission)
        self.type = type
        self.isEditingExistingMission = isEditingExistingMission
        self.goToMissionPreview = goToMissionPreview
        self.missionFinishedEditing = missionFinishedEditing
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack {
                    Text(type.metadata.description)
                        .foregroundColor(Color.accentColor.opacity(0.75))
                        +
                        Text("  ")
                        +
                        Text(Image(systemName: type.metadata.icon))
                        .foregroundColor(.accentColor)
                }
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(y: -10)
                .dynamicHorizontalPadding()

                Mission.propertiesView(mission: $editingMission)
//                switch editingMission.content {
//                case .shake(let properties):
//                    let binding: Binding<ShakeMissionProperties> = Binding {
//                        properties
//                    } set: { newValue in
//                        self.editingMission = .init(id: editingMission.id, content: .shake(properties: newValue))
//                    }
//                    ShakeMissionPropertiesView(properties: binding)
//                case .blocks(let properties):
//                    let binding: Binding<BlocksMissionProperties> = Binding {
//                        properties
//                    } set: { newValue in
//                        self.editingMission = .init(id: editingMission.id, content: .blocks(properties: newValue))
//                    }
//
//                    BlocksMissionPropertiesView(properties: binding)
//                }
            }
            .padding(.top, 8)
            .padding(.bottom, 20)
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button {
                    goToMissionPreview(editingMission)
                } label: {
                    Text("Preview")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .contentShape(Rectangle())
                }

                Spacer()

                Button {
                    missionFinishedEditing(editingMission)
                } label: {
                    Text(isEditingExistingMission && propertiesModified ? "Update" : "Done")
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background {
                            Capsule(style: .continuous)
                                .foregroundColor(.accentColor)
                        }
                }
            }
            .fontWeight(.semibold)
            .padding(.vertical, 20)
            .dynamicHorizontalPadding()
            .background {
                Capsule(style: .continuous)
                    .fill(Color.accentColor)
                    .opacity(0.1)
            }
            .padding(.vertical, 10)
            .dynamicHorizontalPadding()
            .frame(maxWidth: .infinity)
            .background {
                VariableBlurView(gradientMask: UIImage(named: "Gradient-Reversed")!)
                    .ignoresSafeArea()
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle(type.metadata.title)
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: editingMission.content) { newValue in
            propertiesModified = true
        }
    }
}

struct MissionPropertiesViewPreview: View {
    @State var initialMission = Mission(content: .shake())
    @State var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            MissionPropertiesView(
                editingMission: initialMission,
                type: .shake,
                isEditingExistingMission: true
            ) { _ in

            } missionFinishedEditing: { _ in
            }

//            MissionPropertiesView(
//                initialMission: initialMission,
//                path: $path,
//                type: initialMission?.content.type ?? .shake
//            ) { mission in
//            }
            .navigationDestination(for: Mission.self) { mission in
                MissionView(configuration: .preview, mission: mission)
            }
        }
    }
}

struct MissionPropertiesViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        MissionPropertiesViewPreview()
    }
}
