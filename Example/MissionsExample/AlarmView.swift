//
//  AlarmView.swift
//  MissionsExample
//
//  Created by A. Zheng (github.com/aheze) on 6/1/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//
    
import Missions
import SwiftUI

struct AlarmViewBase: View {
    var missions: [Mission]

    @State var showingAlarm = true
    
    var body: some View {
        Color.clear
            .overlay {
                Button("Show Alarm View") {
                    withAnimation {
                        showingAlarm = true
                    }
                }
            }
            .overlay {
                if showingAlarm {
                    AlarmView(missions: missions) {
                        withAnimation {
                            showingAlarm = false
                        }
                    }
                }
            }
    }
}

struct AlarmView: View {
    var missions: [Mission]
    var dismissAlarm: (() -> Void)?
    
    @State var completedMissions = [Mission]()
    var missionsToComplete: [Mission] {
        missions.filter { mission in
            !completedMissions.contains(where: { $0.id == mission.id })
        }
    }
    
    @State var selectedMission: Mission?
    
    @State var pressing = false
    
    var body: some View {
        content
    }
    
    @ViewBuilder var content: some View {
        VStack {
            if let selectedMission {
                let hasAnotherMission = missionsToComplete.count > 1
                    
                MissionView(
                    configuration: .alarm(
                        hasAnotherMission: hasAnotherMission,
                        pressed: {
                            withAnimation {
                                completedMissions.append(selectedMission)
                                
                                print("missionsToComplete: \(missionsToComplete)")
                                self.selectedMission = missionsToComplete.first
                                
                                if self.selectedMission == nil {
                                    dismissAlarm?()
                                }
                            }
                        },
                        backPressed: {
                            print("Back")
                            withAnimation {
                                self.selectedMission = nil
                            }
                        },
                        missionExpired: {
                            print("Expired")
                            withAnimation {
                                self.selectedMission = nil
                            }
                        }
                    ),
                    mission: selectedMission
                )
                .id(selectedMission.id)
                .environment(\.tintColor, .white)
            } else {
                alarmContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image("Lake")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .brightness(-0.2)
                .overlay {
                    VStack {
                        if selectedMission == nil {
                            VariableBlurView(gradientMask: UIImage(named: "Gradient-Reversed")!, style: .systemMaterialLight)
                                .padding(.top, 300)
                        } else {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                        }
                    }
                }
                .ignoresSafeArea()
        }
        .environment(\.colorScheme, .dark)
    }
    
    @ViewBuilder var alarmContent: some View {
        let firstMission = missions.first
        
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Text("Wake up")
                    .font(.largeTitle)
                
                Text("9:41")
                    .font(.system(size: 96, weight: .semibold))
                    .overlay(alignment: .trailingLastTextBaseline) {
                        Text("AM")
                            .font(.title3)
                            .fontWeight(.medium)
                            .opacity(0.25)
                            .alignmentGuide(.trailing) { _ in -6 }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button {
                if let firstMission {
                    withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                        selectedMission = firstMission
                    }
                } else {
                    dismissAlarm?()
                }
            } label: {
                Text(firstMission != nil ? "Start Mission" : "Dismiss")
                    .foregroundColor(.primary)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background {
                        Capsule(style: .continuous)
                            .fill(Color.black)
                            .opacity(0.25)
                    }
            }
            .scaleEffect(pressing ? 0.95 : 1)
            .buttonStyle(DefaultButtonStyle())
            ._onButtonGesture { pressing in
                if pressing {
                    withAnimation(.spring(response: 0.05, dampingFraction: 1, blendDuration: 1)) {
                        self.pressing = pressing
                    }
                } else {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 1)) {
                        self.pressing = pressing
                    }
                }
            } perform: {}
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .shadow(
            color: .black.opacity(0.25),
            radius: 16,
            x: 0,
            y: 10
        )
        .shadow(
            color: .black.opacity(0.25),
            radius: 16,
            x: 0,
            y: 10
        )
    }
}

struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
//        AlarmView(missions: [.init(content: .blocks())])
        AlarmView(missions: [])
    }
}

struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
    }
}
