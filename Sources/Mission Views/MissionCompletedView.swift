//
//  MissionCompletedView.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/30/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

struct MissionCompletedView: View {
    @Environment(\.tintColor) var tintColor
    
    var actionTitle: String
    var action: () -> Void

    @State var shown = false

    let backgroundAnimation = Animation.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 1)
    let animation = Animation.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)

    var body: some View {
        VStack(spacing: 24) {
            CheckmarkShape()
                .trim(from: 0, to: shown ? 1 : 0)
                .stroke(
                    .secondary,
                    style: .init(
                        lineWidth: 5,
                        lineCap: .round
                    )
                )
                .frame(width: 40, height: 45)
                .scaleEffect(shown ? 1 : 0.6)
                .opacity(shown ? 1 : 0)
                .animation(animation.delay(0.3), value: shown)

            Text("Mission Complete!")
                .foregroundStyle(.secondary)
                .font(.title3)
                .fontWeight(.semibold)
                .scaleEffect(shown ? 1 : 0.9)
                .opacity(shown ? 1 : 0)
                .animation(animation.delay(0.5), value: shown)

            MissionPopupButton(title: actionTitle, tintColor: tintColor) {
                action()
            }
            .scaleEffect(shown ? 1 : 0.9)
            .opacity(shown ? 1 : 0)
            .animation(animation.delay(0.6), value: shown)
        }
        .padding(20)
        .padding(.top, 12)
        .background(RoundedRectangle(cornerRadius: 36, style: .continuous).fill(.regularMaterial))
        .overlay {
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .stroke(Color.primary, lineWidth: 0.5)
                .opacity(0.1)
        }
        .shadow(
            color: .black.opacity(0.1),
            radius: 16,
            x: 0,
            y: 8
        )
        .scaleEffect(1)
        .scaleEffect(shown ? 1 : 0.8)
        .animation(backgroundAnimation, value: shown)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                shown = true
            }
        }
    }
}

struct MissionPopupButton: View {
    var title: String
    var tintColor = Color.accentColor
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(tintColor)
                .fontWeight(.semibold)
                .dynamicVerticalPadding()
                .dynamicHorizontalPadding()
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(tintColor.opacity(0.1))
                }
        }
    }
}

struct CheckmarkShape: Shape {
    var bottomPointWidthPercentage = CGFloat(0.4)
    var radius = CGFloat(3)

    func path(in rect: CGRect) -> Path {
        let bottomPointX = bottomPointWidthPercentage * rect.width

        return Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addArc(
                tangent1End: CGPoint(x: bottomPointX, y: rect.maxY),
                tangent2End: CGPoint(x: rect.maxX, y: rect.minY),
                radius: radius
            )
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
    }
}

struct MissionCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        Color.clear
            .overlay {
                MissionCompletedView(actionTitle: "Dismiss Alarm") {}
                    .frame(maxWidth: 300)
                    .dynamicHorizontalPadding()
            }
            .background {
                Color.purple
                    .ignoresSafeArea()
            }
    }
}
