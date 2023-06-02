//
//  Utilities.swift
//  MissionsTest
//
//  Created by A. Zheng (github.com/aheze) on 5/29/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

/// from https://www.avanderlee.com/swiftui/error-alert-presenting/
extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}

struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }

    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }

    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}

public extension View {
    func dynamicHorizontalPadding() -> some View {
        padding(.horizontal, 16)
    }

    func dynamicVerticalPadding() -> some View {
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
public extension View {
    @available(iOS 15.0, *)
    func dynamicOverlay<Target: View>(align originAlignment: Alignment, to targetAlignment: Alignment, @ViewBuilder of target: () -> Target) -> some View {
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
