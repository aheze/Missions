//
//  AlarmEditor.swift
//  MissionsExample
//
//  Created by A. Zheng (github.com/aheze) on 6/1/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//
    
import Missions
import SwiftUI

enum MissionDestination: Hashable {
    case newMission
    case existingMission(mission: Mission)
}

struct AlarmEditor: View {
    @Binding var selectedMissions: [Mission]
    @Binding var path: NavigationPath
    
    var body: some View {
        content
            .dynamicHorizontalPadding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
            }
            .navigationTitle("Alarm Editor")
            .navigationDestination(for: MissionDestination.self) { destination in
                switch destination {
                case .newMission:
                    MissionsView(path: $path)
                case .existingMission(let mission):
                    MissionPropertiesView(
                        editingMission: mission,
                        type: mission.content.type,
                        isEditingExistingMission: true
                    ) { mission in
                        path.append(mission)
                    } missionFinishedEditing: { mission in
                        if let index = selectedMissions.firstIndex(where: { $0.id == mission.id }) {
                            selectedMissions[index] = mission
                            path.removeLast(path.count)
                        } else {
                            print("No index: \(selectedMissions.map { $0.id })")
                        }
                    }
                    .toolbarRole(.editor)
                }
            }
            .navigationDestination(for: MissionType.self) { type in
                
                MissionPropertiesView(
                    editingMission: .init(content: type.defaultMissionContent),
                    type: type,
                    isEditingExistingMission: false
                ) { mission in
                    path.append(mission)
                } missionFinishedEditing: { mission in
                    selectedMissions.append(mission)
                    path.removeLast(path.count)
                }
            }
            .navigationDestination(for: Mission.self) { mission in
                MissionView(configuration: .preview, mission: mission)
                    .toolbarRole(.editor)
            }
    }
    
    var content: some View {
        VStack(spacing: 0) {
            missionRow
                .padding(.bottom, selectedMissions.isEmpty ? 14 : 0)
            
            if !selectedMissions.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(selectedMissions) { mission in
                            AlarmEditorMissionView(
                                selectedMissions: $selectedMissions,
                                path: $path,
                                mission: mission
                            )
                            .overlay(align: .topTrailing, to: .center) {
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                                        selectedMissions = selectedMissions.filter { $0.id != mission.id }
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.primary)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .frame(width: 26, height: 26)
                                        .background {
                                            Circle()
                                                .fill(.ultraThickMaterial)
                                        }
                                        .overlay {
                                            Circle()
                                                .stroke(Color.primary, lineWidth: 0.25)
                                                .opacity(0.25)
                                        }
                                }
                            }
                        }
                    }
                    .dynamicHorizontalPadding()
                    .padding(.top, 14)
                    .padding(.bottom, 16)
                }
                .frame(height: 120)
            }
        }
        .background {
            Color(uiColor: .secondarySystemGroupedBackground)
        }
        .mask {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
        }
    }
    
    var missionRow: some View {
        Button {
            path.append(MissionDestination.newMission)
        } label: {
            HStack {
                VStack {
                    let countString: String = {
                        if selectedMissions.count > 1 {
                            return " (\(selectedMissions.count))"
                        }
                        return ""
                    }()
                    
                    Text(selectedMissions.count == 1 ? "Mission" : "Missions")
                        + Text(countString)
                        .foregroundColor(.primary.opacity(0.5))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "plus")
            }
            .foregroundColor(.primary)
            .dynamicHorizontalPadding()
            .padding(.top, 14)
        }
    }
}

struct AlarmEditorMissionView: View {
    @Binding var selectedMissions: [Mission]
    @Binding var path: NavigationPath
    var mission: Mission
    
    var body: some View {
        Button {
            path.append(MissionDestination.existingMission(mission: mission))
        } label: {
            content
        }
    }
    
    @ViewBuilder var content: some View {
        let metadata = mission.content.type.metadata
        
        VStack(alignment: .leading) {
            Image(systemName: metadata.icon)
                .font(.title3)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            Text(metadata.title)
                .font(.title2)
                .minimumScaleFactor(0.8)
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 100, maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color(uiColor: .systemGroupedBackground))
        .mask {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
        }
    }
}

struct AlarmEditorBase: View {
    @Binding var selectedMissions: [Mission]
    
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            AlarmEditor(selectedMissions: $selectedMissions, path: $path)
        }
    }
}

struct AlarmEditorPreview: View {
    @State var selectedMissions = [Mission]()
    
    var body: some View {
        AlarmEditorBase(selectedMissions: $selectedMissions)
    }
}

struct AlarmEditorPreviewProvider: PreviewProvider {
    static var previews: some View {
        AlarmEditorPreview()
    }
}
