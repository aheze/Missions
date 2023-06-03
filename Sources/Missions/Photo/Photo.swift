//
//  File.swift
//
//
//  Created by A. Zheng (github.com/aheze) on 6/2/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

// MARK: - Mission properties

public struct PhotoMissionProperties: Hashable, Codable {
    public var sensitivity = Double(0.5)
    public var imageData: Data? {
        didSet {
            print("Set image data! \(imageData)")
        }
    }

    public var featurePrintData: Data?

    public init(sensitivity: Double = Double(0.5), imageData: Data? = nil, featurePrintData: Data? = nil) {
        self.sensitivity = sensitivity
        self.imageData = imageData
        self.featurePrintData = featurePrintData
    }
}
