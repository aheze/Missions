//
//  Utilities.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/29/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

extension View {
    func horizontalEdgePadding() -> some View {
        padding(.horizontal, 16)
    }
    
    func verticalRowPadding() -> some View {
        padding(.vertical, 14)
    }

    func groupedBackground() -> some View {
        background(Color(uiColor: .secondarySystemGroupedBackground))
            .mask {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
            }
    }
}

func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
    return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
}

func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
    return sqrt(CGPointDistanceSquared(from: from, to: to))
}

/// from https://stackoverflow.com/a/68555127/14351818
extension View {
    @available(iOS 15.0, *)
    func overlay<Target: View>(align originAlignment: Alignment, to targetAlignment: Alignment, @ViewBuilder of target: () -> Target) -> some View {
        let hGuide = HorizontalAlignment(Alignment.TwoSided.self)
        let vGuide = VerticalAlignment(Alignment.TwoSided.self)
        return alignmentGuide(hGuide) { $0[originAlignment.horizontal] }
            .alignmentGuide(vGuide) { $0[originAlignment.vertical] }
            .overlay(alignment: Alignment(horizontal: hGuide, vertical: vGuide)) {
                target()
                    .alignmentGuide(hGuide) { $0[targetAlignment.horizontal] }
                    .alignmentGuide(vGuide) { $0[targetAlignment.vertical] }
            }
    }
}

extension Alignment {
    enum TwoSided: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat { 0 }
    }
}
