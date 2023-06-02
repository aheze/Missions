//
//  Shake.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/29/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

// MARK: - Mission properties

public struct ShakeMissionProperties: MissionProperties, Hashable, Codable {
    public var type = MissionType.shake
    public var sensitivity = Double(0.5)
    public var numberOfShakes = 20
    
    public init(sensitivity: Double = Double(0.5), numberOfShakes: Int = 20) {
        self.sensitivity = sensitivity
        self.numberOfShakes = numberOfShakes
    }
}

// MARK: - Mission properties view

struct ShakeMissionPropertiesView: View {
    @Binding var properties: ShakeMissionProperties

    var body: some View {
        VStack(spacing: 24) {
            MissionPropertiesGroupView(header: "Shake Sensitivity") {
                VStack {
                    Slider(
                        value: $properties.sensitivity,
                        in: 0 ... 1,
                        step: 0.25
                    ) {} onEditingChanged: { _ in
                    }

                    HStack {
                        Text("Easy")

                        Spacer()

                        Text("Hard")
                    }
                    .foregroundColor(.secondary)
                }
                .verticalPadding()
                .dynamicHorizontalPadding()
                .frame(maxWidth: .infinity)
            }

            MissionPropertiesGroupView(header: "Number of Shakes") {
                Picker("Number of shakes", selection: $properties.numberOfShakes) {
                    ForEach(5 ..< 150) { number in
                        Text("\(number)")
                            .tag(number)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: 120)
                .frame(maxWidth: .infinity)
            }
        }
        .dynamicHorizontalPadding()
    }
}

// MARK: - Mission view

struct ShakeMissionView: View {
    @Environment(\.debugMode) var debugMode
    @Environment(\.missionCompletion) var missionCompletion
    @Environment(\.missionUserInteractionOccurred) var missionUserInteractionOccurred

    var properties: ShakeMissionProperties

    @State var shakesSoFar = 0

    var body: some View {
        VStack {
            Text("Shake Your Phone")
                .opacity(0.5)
                .textCase(.uppercase)
                .font(.callout)

            Text("\(properties.numberOfShakes - shakesSoFar)")
                .font(.system(size: 120, weight: .medium, design: .rounded))

            if debugMode {
                Button("Test shake") {
                    incrementShake()
                }
            }
        }
    }

    func incrementShake() {
        missionUserInteractionOccurred?()
        shakesSoFar += 1

        if shakesSoFar >= properties.numberOfShakes {
            missionCompletion?()
        }
    }
}

// MARK: - Previews

struct ShakeMissionPropertiesViewPreview: View {
    @State var properties = ShakeMissionProperties()

    var body: some View {
        ScrollView {
            ShakeMissionPropertiesView(properties: $properties)
                .dynamicHorizontalPadding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

struct ShakeMissionPropertiesViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        ShakeMissionPropertiesViewPreview()
    }
}

struct ShakeMissionView_Previews: PreviewProvider {
    static var previews: some View {
        ShakeMissionView(properties: .init())
    }
}
