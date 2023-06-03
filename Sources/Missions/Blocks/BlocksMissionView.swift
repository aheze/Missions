//
//  BlocksMissionView.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/30/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import Prism
import SwiftUI

// MARK: - Mission view

struct BlocksMissionView: View {
    @Environment(\.tintColor) var tintColor
    @Environment(\.debugMode) var debugMode
    @Environment(\.missionCompletion) var missionCompletion
    @Environment(\.missionUserInteractionOccurred) var missionUserInteractionOccurred
    @Environment(\.missionCompleted) var missionCompleted

    var properties: BlocksMissionProperties

    @StateObject var model = SwiftUICraftViewModel()
    @StateObject var overlayModel = SwiftUICraftViewModel()

    @State var overlayExpanded = true
    @State var overlayAlignment = Alignment.topLeading
    @State var initialized = false
    @State var questionPressed = false

    var body: some View {
        VStack(spacing: 0) {
            GameView(model: model)
                .onAppear {
                    model.blocksUpdated = {
                        handleAddedBlock()
                    }
                }
                .overlay {
                    VStack(spacing: 20) {
                        if !missionCompleted {
                            GeometryReader { geometry in
                                Color.clear
                                    .overlay(alignment: overlayAlignment) {
                                        BlocksMissionOverlayView(
                                            model: overlayModel,
                                            availableSize: geometry.size,
                                            overlayExpanded: $overlayExpanded,
                                            overlayAlignment: $overlayAlignment
                                        )
                                    }
                            }
                            .dynamicHorizontalPadding()
                        }
                    }
                    .padding(.bottom, 20)
                }
                .onAppear {
                    model.selectedItem = .grass
                }

            if !missionCompleted {
                toolbar
                    .dynamicOverlay(align: .topTrailing, to: .center) {
                        Button {
                            missionUserInteractionOccurred?()
                            questionPressed = true
                        } label: {
                            Image(systemName: "questionmark")
                                .foregroundColor(.secondary)
                                .frame(width: 36, height: 36)
                                .background {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .overlay {
                                            Circle()
                                                .stroke(Color.secondary, lineWidth: 0.5)
                                                .opacity(0.25)
                                        }
                                }
                        }
                        .offset(x: -8, y: 8)
                    }
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            onAppear()
        }
        .onChange(of: missionCompleted) { newValue in
            if newValue {
                withAnimation(.spring(response: 0.6, dampingFraction: 1, blendDuration: 1)) {
                    overlayExpanded = false
                }
            }
        }
        .alert("Having Trouble?", isPresented: $questionPressed) {
            Button("Shuffle World") {
                shuffle()
            }
            
            Button("Nevermind") {}
        } message: {
            Text("You can shuffle to a different world if you want, but your progress will be lost.")
        }

    }

    var toolbar: some View {
        OverflowLayout(spacing: 0) {
            ForEach(model.level.items, id: \.self) { item in
                let selected = model.selectedItem == item

                Button {
                    model.selectedItem = item
                } label: {
                    itemView(item: item)
                        .frame(width: 80, height: 80)
                        .background {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(tintColor)
                                .opacity(selected ? 0.1 : 0)
                        }
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 36, style: .continuous))
        .environment(\.colorScheme, .light)
    }

    func itemView(item: Item) -> some View {
        VStack {
            switch item.preview {
            case let .image(image):
                Image(image, bundle: .module)
                    .interpolation(.none)
                    .resizable()
                    .padding(18)
                    .offset(y: -3)
            case let .blockView(blockView):
                PrismCanvas(tilt: 1) {
                    blockView
                }
                .scaleEffect(y: 0.69)
                .offset(y: 8)
            }
        }
    }

    func handleAddedBlock() {
        missionUserInteractionOccurred?()

        if Set(model.level.world.blocks) == Set(overlayModel.level.world.blocks) {
            missionCompletion?()
        }
    }
}

struct BlocksMissionView_Previews: PreviewProvider {
    static var previews: some View {
        BlocksMissionView(properties: .init())
    }
}
