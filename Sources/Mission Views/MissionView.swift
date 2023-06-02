//
//  MissionView.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/30/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

public enum MissionViewConfiguration {
    case preview

    /// 1. if there's another mission after this one
    /// 2. pressed the "Next Mission" / "Dismiss Alarm" button
    /// 3. back button on the top-left pressed
    /// 4. if the mission expired, go back
    case alarm(hasAnotherMission: Bool, pressed: (() -> Void)?, backPressed: (() -> Void)?, missionExpired: (() -> Void)?)
}

public struct MissionView: View {
    @Environment(\.tintColor) var tintColor
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.missionTimeLimit) var missionTimeLimit

    public var configuration: MissionViewConfiguration
    public var mission: Mission

    @State var soundOn = false
    @State var complete = false
    @State var showingPreviewExpiredAlert = false
    @State var timeElapsedWithoutUserInteraction = Double(0)
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var showProgressView: Bool {
        missionTimeLimit - timeElapsedWithoutUserInteraction < 10
    }
    
    public init(configuration: MissionViewConfiguration, mission: Mission) {
        self.configuration = configuration
        self.mission = mission
    }

    public var body: some View {
        let type = mission.content.type

        switch configuration {
        case .preview:
            content
                .navigationTitle(type.metadata.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            soundOn.toggle()
                        } label: {
                            Image(systemName: soundOn ? "speaker.fill" : "speaker.slash.fill")
                        }
                    }
                }
        case .alarm(let hasAnotherMission, let pressed, let backPressed, let missionExpired):
            VStack {
                HStack {
                    Button {
                        backPressed?()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.headline)
                            .fontWeight(.medium)
                            .contentShape(Rectangle())
                    }

                    Spacer()

                    Button {
                        soundOn.toggle()
                    } label: {
                        Image(systemName: soundOn ? "speaker.fill" : "speaker.slash.fill")
                    }
                }
                .overlay {
                    Text(type.metadata.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(tintColor)
                .dynamicHorizontalPadding()
                .padding(.top, 10)
                .padding(.bottom, 6)

                content
            }
        }
    }

    @ViewBuilder var content: some View {
        let progress = max(0, 1 - CGFloat(timeElapsedWithoutUserInteraction / missionTimeLimit))

        VStack(spacing: 16) {
            if !complete, showProgressView {
                MissionsProgressView(tintColor: tintColor, progress: progress)
                    .frame(height: 3)
                    .dynamicHorizontalPadding()
            }

            VStack {
                switch mission.content {
                case .shake(let properties):
                    ShakeMissionView(properties: properties)
                case .blocks(let properties):
                    BlocksMissionView(properties: properties)
                }
            }
            .environment(\.missionUserInteractionOccurred, resetAfterUserInteraction)
            .environment(\.missionCompleted, complete)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.top, 4)
        .overlay(alignment: .top) {
            VStack {
                if complete {
                    switch configuration {
                    case .preview:
                        MissionCompletedView(actionTitle: "Exit Preview") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(maxWidth: 300)
                        .dynamicHorizontalPadding()
                    case .alarm(let hasAnotherMission, let pressed, _, _):
                        MissionCompletedView(actionTitle: hasAnotherMission ? "Next Mission" : "Dismiss Alarm") {
                            pressed?()
                        }
                        .frame(maxWidth: 300)
                        .dynamicHorizontalPadding()
                    }
                }

                if showingPreviewExpiredAlert {
                    MissionExpiredView {
                        withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                            resetAfterUserInteraction()
                            showingPreviewExpiredAlert = false
                        }
                    }
                    .frame(maxWidth: 300)
                    .dynamicHorizontalPadding()
                }
            }
            .padding(.top, 20)
        }
        .environment(\.missionCompletion, missionCompleted)
        .onReceive(timer) { _ in
            guard !complete else { return }
            withAnimation(.linear(duration: 0.5)) {
                timeElapsedWithoutUserInteraction += 0.5
            }

            if timeElapsedWithoutUserInteraction >= missionTimeLimit {
                missionExpired()
            }
        }
    }

    func resetAfterUserInteraction() {
        withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
            timeElapsedWithoutUserInteraction = 0
        }
    }

    func missionExpired() {
        switch configuration {
        case .preview:
            withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                showingPreviewExpiredAlert = true
            }
        case .alarm(_, _, _, let missionExpired):
            missionExpired?()
        }
    }

    func missionCompleted() {
        withAnimation(.spring(response: 0.6, dampingFraction: 1, blendDuration: 1)) {
            complete = true
        }
    }
}

struct MissionsProgressView: View {
    var tintColor: Color
    var progress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            Capsule(style: .circular)
                .fill(tintColor)
                .opacity(0.1)
                .overlay(alignment: .leading) {
                    Capsule(style: .circular)
                        .fill(tintColor)
                        .frame(width: max(1, progress * geometry.size.width))
                        .opacity(progress <= 0.02 ? 0 : 1)
                }
        }
    }
}

struct MissionViewPreview: View {
    @State var mission: Mission = .init(content: .blocks())

    var body: some View {
        NavigationStack {
            MissionView(configuration: .preview, mission: mission)
        }
    }
}

struct MissionViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        MissionViewPreview()
    }
}
