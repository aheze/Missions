//
//  Shake.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/29/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import Combine
import CoreMotion
import SwiftUI

// MARK: - Mission properties

public struct ShakeMissionProperties: Codable, Hashable {
    public var type = MissionType.shake
    public var sensitivity = Double(0.5)
    public var numberOfShakes = 10

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
                .dynamicVerticalPadding()
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
    @State var manager = CMMotionManager()
    @State var hasError = false

    var body: some View {
        VStack {
            Text("Shake Your Phone")
                .opacity(0.5)
                .textCase(.uppercase)
                .font(.callout)

            let shakes = max(0, properties.numberOfShakes - shakesSoFar) /// prevent going under 0

            Text("\(shakes)")
                .font(.system(size: 120, weight: .medium, design: .rounded))

            if debugMode {
                Button("Test shake") {
                    incrementShake()
                }
            }

            if hasError {
                Text("Couldn't activate accelerometer")

                Button("Tap me instead :)") {
                    incrementShake()
                }
            }
        }
        .onAppear {
            manager.startAccelerometerUpdates(to: .main) { data, error in

                guard let data = data, error == nil else {
                    print("Couldn't get accelerometer data: \(error)")
                    hasError = true
                    return
                }

                /// from https://stackoverflow.com/a/38345094/14351818
                let accelerationThreshold = 0.2

                let acceleration = data.acceleration
                if abs(acceleration.x) > accelerationThreshold || abs(acceleration.y) > accelerationThreshold || abs(acceleration.z) > accelerationThreshold {
                    let sensitivity = Double(properties.sensitivity * 3.9)
                    var x1 = Double(0)
                    var x2 = Double(0)
                    var y1 = Double(0)
                    var y2 = Double(0)
                    var z1 = Double(0)
                    var z2 = Double(0)

                    let totalAccelerationInXY: Double = sqrt(acceleration.x * acceleration.x + acceleration.y + acceleration.y)

                    if totalAccelerationInXY > 0.85, totalAccelerationInXY < 3.45 {
                        x1 = acceleration.x
                        y1 = acceleration.y
                        z1 = acceleration.z

                        let change: Double = abs(x1 - x2 + y1 - y2 + z1 - z2)
                        if sensitivity < change {
                            print("total=\(totalAccelerationInXY) x=\(acceleration.x) y=\(acceleration.y) z=\(acceleration.z). Sens: \(properties.sensitivity) vs \(change)")

                            x2 = x1
                            y2 = y1
                            z2 = z1

                            if properties.sensitivity < 0.4 {
                                /// make shakes faster
                                Throttler.throttle(delay: .seconds(0.2)) {
                                    incrementShake()
                                }
                            } else {
                                Throttler.throttle(delay: .seconds(0.42)) {
                                    incrementShake()
                                }
                            }
                        }
                    }
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

/// from https://github.com/boraseoksoon/Throttler
/// struct throttling successive works with provided options.
public enum Throttler {
    typealias WorkIdentifier = String

    typealias Work = () -> Void
    typealias Subject = PassthroughSubject<Work, Never>?
    typealias Bag = Set<AnyCancellable>

    private static var subjects: [WorkIdentifier: Subject] = [:]
    private static var bags: [WorkIdentifier: Bag] = [:]

    /// Throttle a work
    ///
    ///     var sec = 0
    ///     for i in 0...1000000000 {
    ///         Throttler.throttle {
    ///             sec += 1
    ///             Debug.log("your work done : \(i)")
    ///         }
    ///     }
    ///
    ///     Debug.log("done!")
    ///
    ///
    ///     "your work done : 1"
    ///     (after a delay)
    ///     "your work done : x"
    ///     (after a delay)
    ///     "your work done : y"
    ///     (after a delay)
    ///     "your work done : z"
    ///     ....
    ///     ...
    ///     ..
    ///     .
    ///     "your work done : 1000000000"
    ///
    ///     "done!"
    ///
    /// - Note: Pay special attention to the identifier parameter. the default identifier is \("Thread.callStackSymbols") to make api trailing closure for one liner for the sake of brevity. However, it is highly recommend that a developer should provide explicit identifier for their work to debounce. Also, please note that the default queue is global queue, it may cause thread explosion issue if not explicitly specified , so use at your own risk.
    ///
    /// - Parameters:
    ///   - identifier: the identifier to group works to throttle. Throttler must have equivalent identifier to each work in a group to throttle.
    ///   - queue: a queue to run a work on. dispatch global queue will be chosen by default if not specified.
    ///   - delay: delay for throttle. time unit is second. given default is 1.0 sec.
    ///   - shouldRunImmediately: a boolean type where true will run the first work immediately regardless.
    ///   - shouldRunLatest: A Boolean value that indicates whether to publish the most recent element. If `false`, the publisher emits the first element received during the interval.
    ///   - work: a work to run
    /// - Returns: Void
    public static func throttle(identifier: String = "\(Thread.callStackSymbols)",
                                queue: DispatchQueue? = nil,
                                delay: DispatchQueue.SchedulerTimeType.Stride = .seconds(1),
                                shouldRunImmediately: Bool = true,
                                shouldRunLatest: Bool = true,
                                work: @escaping () -> Void)
    {
        let isFirstRun = subjects[identifier] == nil ? true : false

        if shouldRunImmediately, isFirstRun {
            work()
        }

        if let _ = subjects[identifier] {
            subjects[identifier]?!.send(work)
        } else {
            subjects[identifier] = PassthroughSubject<Work, Never>()
            bags[identifier] = Bag()

            let q = queue ?? .global()

            subjects[identifier]?!
                .throttle(for: delay, scheduler: q, latest: shouldRunLatest)
                .sink(receiveValue: { $0() })
                .store(in: &bags[identifier]!)
        }
    }
}
