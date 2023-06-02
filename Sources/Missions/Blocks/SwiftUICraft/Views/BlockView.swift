//
//  BlockView.swift
//  SwiftUICraft
//
//  Created by A. Zheng (github.com/aheze) on 11/9/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//
    
import Prism
import SwiftUI

/**
 A single block for drawing in `GameView`.
 
 Powered by Prism.
 */
struct BlockView: View {
    var selectedItem: Item?
    var tilt: CGFloat
    var length: CGFloat
    var levitation: CGFloat
    var block: Block
    
    var topTapped: (() -> Void)?
    var leftTapped: (() -> Void)?
    var rightTapped: (() -> Void)?
    var held: (() -> Void)? /// For long press / block breaking.
    
    @State var animated = false

    var top: some View {
        Group {
            switch block.blockKind.texture {
            case let .differentSides(top, _):
                Image(top)
                    .interpolation(.none)
                    .resizable()
            case let .image(image):
                Image(image)
                    .interpolation(.none)
                    .resizable()
            case .laser:
                Color.yellow.opacity(0.5)
            }
        }
    }
    
    var left: some View {
        Group {
            switch block.blockKind.texture {
            case let .differentSides(_, sides):
                Image(sides)
                    .interpolation(.none)
                    .resizable()
                    .brightness(-0.1)
            case let .image(image):
                Image(image)
                    .interpolation(.none)
                    .resizable()
                    .brightness(-0.1)
            case .laser:
                Color.yellow.opacity(0.3)
                    .overlay {
                        Rectangle()
                            .strokeBorder(
                                Color.primary,
                                style: .init(
                                    lineWidth: 1,
                                    lineCap: .square,
                                    dash: [40, 20],
                                    dashPhase: animated ? -240 : 0
                                )
                            )
                            .animation(.linear(duration: 0.9).repeatForever(autoreverses: false), value: animated)
                    }
                    .overlay(alignment: .bottom) {
                        Text("midnight.day")
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(Color.primary)
                            .tracking(2)
                            .opacity(0.75)
                            .fixedSize()
                            .rotationEffect(.degrees(-90))
                            .offset(y: -180)
                    }
            }
        }
    }
    
    var right: some View {
        Group {
            switch block.blockKind.texture {
            case let .differentSides(_, sides):
                Image(sides)
                    .interpolation(.none)
                    .resizable()
                    .brightness(-0.2)
            case let .image(image):
                Image(image)
                    .interpolation(.none)
                    .resizable()
                    .brightness(-0.2)
            case .laser:
                Color.yellow.opacity(0.2)
                    .overlay {
                        Rectangle()
                            .strokeBorder(
                                Color.white,
                                style: .init(
                                    lineWidth: 1,
                                    lineCap: .square,
                                    dash: [40, 20],
                                    dashPhase: animated ? 240 : 0
                                )
                            )
                            .animation(.linear(duration: 0.9).repeatForever(autoreverses: false), value: animated)
                    }
            }
        }
    }
    
    var body: some View {
        let extrusion: CGFloat = {
            if block.blockKind == .laser {
                if block.active {
                    return length * 10
                } else {
                    return length * 0.2
                }
            } else {
                if block.active {
                    return length * block.extrusionMultiplier
                } else {
                    if block.extrusionMultiplier > 1 {
                        return length * 0.2 /// water in the air
                    } else {
                        return 0 /// water on ground
                    }
                }
            }
        }()
        
        let adjustedLength: CGFloat = {
            if block.blockKind == .laser {
                return length * 0.5
            } else {
                return length
            }
        }()
        
        let adjustedLevitation: CGFloat = {
            if block.active {
                return levitation
            } else {
                if block.extrusionMultiplier > 1 {
                    return levitation + length * (block.extrusionMultiplier - 0.2)
                } else {
                    return levitation
                }
            }
        }()
        
        PrismView(
            tilt: tilt,
            size: .init(width: adjustedLength, height: adjustedLength),
            extrusion: extrusion,
            levitation: adjustedLevitation,
            shadowOpacity: 0.25
        ) {
            if let topTapped, let held {
                top
                    .onTapGesture {
                        if selectedItem?.associatedBlockKind == nil {
                            held()
                        } else {
                            topTapped()
                        }
                    }
                    .onLongPressGesture(minimumDuration: Block.holdDurationForRemoval) {
                        held()
                    }
            } else {
                top
            }
            
        } left: {
            if let leftTapped, let held {
                left
                    .onTapGesture {
                        if selectedItem?.associatedBlockKind == nil {
                            held()
                        } else {
                            leftTapped()
                        }
                    }
                    .onLongPressGesture(minimumDuration: Block.holdDurationForRemoval) {
                        held()
                    }
            } else {
                left
            }
        } right: {
            if let rightTapped, let held {
                right
                    .onTapGesture {
                        if selectedItem?.associatedBlockKind == nil {
                            held()
                        } else {
                            rightTapped()
                        }
                    }
                    .onLongPressGesture(minimumDuration: Block.holdDurationForRemoval) {
                        held()
                    }
            } else {
                right
            }
        }
        .frame(width: length, height: length)
        .opacity(block.active ? 1 : 0)
        .onAppear {
            animated = true
        }
    }
}
