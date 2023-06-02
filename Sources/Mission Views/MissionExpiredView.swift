//
//  MissionExpiredView.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/30/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//
    

import SwiftUI

struct MissionExpiredView: View {
    @Environment(\.presentationMode) var presentationMode
    var resetTimer: () -> Void
    
    @State var shown = false
    
    let backgroundAnimation = Animation.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 1)
    let animation = Animation.spring(response: 0.3, dampingFraction: 1, blendDuration: 1)
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "zzz")
                .font(.system(size: 50, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
                .scaleEffect(shown ? 1 : 0.6)
                .opacity(shown ? 1 : 0)
                .animation(animation.delay(0.3), value: shown)
            

            Text("Are you awake?")
                .foregroundStyle(.secondary)
                .font(.title3)
                .fontWeight(.semibold)
                .scaleEffect(shown ? 1 : 0.9)
                .opacity(shown ? 1 : 0)
                .animation(animation.delay(0.5), value: shown)

            HStack(spacing: 12) {
                MissionPopupButton(title: "Continue Mission", tintColor: .secondary) {
                    resetTimer()
                }
                .scaleEffect(shown ? 1 : 0.9)
                .opacity(shown ? 1 : 0)
                .animation(animation.delay(0.6), value: shown)
                
                MissionPopupButton(title: "Exit Preview") {
                    presentationMode.wrappedValue.dismiss()
                }
                .scaleEffect(shown ? 1 : 0.9)
                .opacity(shown ? 1 : 0)
                .animation(animation.delay(0.8), value: shown)
            }
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

struct MissionExpiredView_Previews: PreviewProvider {
    static var previews: some View {
        Color.clear
            .overlay {
                MissionExpiredView {}
                    .frame(maxWidth: 300)
                    .dynamicHorizontalPadding()
            }
            .background {
                Color.orange
                    .ignoresSafeArea()
            }
    }
}
