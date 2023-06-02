//
//  BlocksMissionOverlayView.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/30/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

struct BlocksMissionOverlayView: View {
    @ObservedObject var model: SwiftUICraftViewModel
    var availableSize: CGSize
    @Binding var overlayExpanded: Bool
    @Binding var overlayAlignment: Alignment

    var baseLength = CGFloat(140)
    @State var length = CGFloat(200)
    @State var offset = CGSize.zero

    var body: some View {
        content
            .coordinateSpace(name: "Overlay")
            .overlay(alignment: overlayAlignment.isLeading ? .bottomTrailing : .bottomLeading) {
                if overlayExpanded {
                    CurveShape(radius: 20)
                        .stroke(Color.primary, style: .init(lineWidth: 3, lineCap: .round))
                        .opacity(0.25)
                        .frame(width: 16, height: 16)
                        .padding(10)
                        .padding(.top, 20)
                        .padding(.leading, 20)
                        .contentShape(Rectangle())
                        .scaleEffect(x: overlayAlignment.isLeading ? 1 : -1)
                }
            }
            .gesture(
                DragGesture(coordinateSpace: .named("Overlay"))
                    .onChanged { value in
                        var length = max(value.location.x, value.location.y)
                        length = max(length, baseLength)

                        withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                            self.length = length
                        }
                    }
            )
            .frame(maxWidth: overlayExpanded ? length : nil, maxHeight: overlayExpanded ? length * 7 / 6 : nil)
            .background {
                RoundedRectangle(cornerRadius: 36, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .light)
            }
            .mask {
                RoundedRectangle(cornerRadius: 36, style: .continuous)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 36, style: .continuous)
                    .stroke(Color.primary, lineWidth: 0.5)
                    .opacity(0.1)
            }
            .shadow(
                color: .black.opacity(0.1),
                radius: 16,
                x: 0,
                y: 10
            )
            .offset(offset)
    }

    @ViewBuilder var content: some View {
        VStack {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)) {
                    overlayExpanded.toggle()
                }
            } label: {
                HStack {
                    if overlayExpanded {
                        Text("Goal")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Image(systemName: "plus")
                        .rotationEffect(.degrees(overlayExpanded ? 45 : 0))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, overlayExpanded ? 16 : 20)
            }
            .font(.title3)
            .foregroundColor(.secondary)
            .background(.thinMaterial)
            .mask {
                RoundedRectangle(cornerRadius: 36, style: .continuous)
            }
            .environment(\.colorScheme, .light)
            .scaleEffect(1)
            .highPriorityGesture(
                DragGesture(minimumDistance: 5)
                    .onChanged { value in
                        withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                            offset = value.translation
                            processHeaderDrag(value: value)
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring(response: 0.6, dampingFraction: 1, blendDuration: 1)) {
                            offset = .zero
                            processHeaderDrag(value: value)
                        }
                    }
            )

            if overlayExpanded {
                Spacer()
            }
        }
        .background {
            let scale = (length / baseLength) / 2.5
            let cappedScale = min(0.9, scale)
            let offset = (length / baseLength) / 0.02
            let offsetHeight = -model.initialYOffset + offset - 20

            if overlayExpanded {
                GameView(model: model, scale: cappedScale, offset: CGSize(width: 0, height: offsetHeight), allowsBlockManipulation: false)
            }
        }
    }

    func processHeaderDrag(value: DragGesture.Value) {
        let topLeftMidpoint = CGPoint(x: length / 2, y: length / 2)
        let topRightMidpoint = CGPoint(x: availableSize.width - length / 2, y: length / 2)
        let bottomLeftMidpoint = CGPoint(x: length / 2, y: availableSize.height - length / 2)
        let bottomRightMidpoint = CGPoint(x: availableSize.width - length / 2, y: availableSize.height - length / 2)

        var midpoint: CGPoint = {
            switch overlayAlignment {
            case .topLeading:
                return topLeftMidpoint
            case .topTrailing:
                return topRightMidpoint
            case .bottomLeading:
                return bottomLeftMidpoint
            case .bottomTrailing:
                return bottomRightMidpoint
            default:
                return topLeftMidpoint
            }
        }()

        midpoint.x += value.translation.width
        midpoint.y += value.translation.height

        let midpoints: [(CGPoint, Alignment)] = [
            (topLeftMidpoint, .topLeading),
            (topRightMidpoint, .topTrailing),
            (bottomLeftMidpoint, .bottomLeading),
            (bottomRightMidpoint, .bottomTrailing),
        ]

        let closestPoint = midpoints.min { a, b in
            CGPointDistanceSquared(from: midpoint, to: a.0) < CGPointDistanceSquared(from: midpoint, to: b.0)
        }

        if let closestPoint {
            overlayAlignment = closestPoint.1
        }
    }
}

struct CurveShape: Shape {
    var radius = CGFloat(3)
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addArc(
                tangent1End: CGPoint(x: rect.maxX, y: rect.maxY),
                tangent2End: CGPoint(x: rect.maxX, y: rect.minY),
                radius: radius
            )
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
    }
}

struct BlocksMissionOverlayViewPreview: View {
    @StateObject var model = SwiftUICraftViewModel(
        level: Level(
            world: WorldParser.process(string: WorldParser.tree),
            items: [],
            background: []
        )
    )
    @State var overlayExpanded = true
    @State var overlayAlignment = Alignment.topLeading

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .overlay {
                    RoundedRectangle(cornerRadius: 36, style: .continuous)
                        .stroke(Color.blue, lineWidth: 1)
                        .opacity(0.5)
                }
                .overlay(alignment: overlayAlignment) {
                    BlocksMissionOverlayView(model: model, availableSize: geometry.size, overlayExpanded: $overlayExpanded, overlayAlignment: $overlayAlignment)
                }
        }
        .padding(24)
        .padding(.bottom, 200)
    }
}

struct BlocksMissionOverlayViewPreviewProvider: PreviewProvider {
    static var previews: some View {
        BlocksMissionOverlayViewPreview()
    }
}

extension Alignment {
    var isLeading: Bool {
        switch self {
        case .topLeading, .bottomLeading:
            return true
        default:
            return false
        }
    }

//    var opposite: Alignment {
//        switch self {
//        case .topLeading:
//            return .bottomTrailing
//        case .topTrailing:
//            return .bottomLeading
//        case .bottomLeading:
//            return .bottomTrailing
//        case .bottomTrailing:
//            return .bottomLeading
//        default:
//            return .center
//        }
//    }
}
