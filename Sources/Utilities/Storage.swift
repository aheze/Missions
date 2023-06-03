//
//  File.swift
//  
//
//  Created by A. Zheng (github.com/aheze) on 6/2/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//
    

import SwiftUI

@propertyWrapper
struct Storage<T: AppStorageConvertible>: RawRepresentable {
    var rawValue: String { wrappedValue.storedValue }
    var wrappedValue: T

    init?(rawValue: String) {
        guard let value = T(rawValue) else { return nil }
        self.wrappedValue = value
    }

    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

extension Binding {
    func binding<T>() -> Binding<T> where Value == Storage<T> {
        return .init(
            get: { wrappedValue.wrappedValue },
            set: { value, transaction in
                self.transaction(transaction).wrappedValue.wrappedValue = value
            }
        )
    }
}

protocol AppStorageConvertible {
    init?(_ storedValue: String)
    var storedValue: String { get }
}

extension RawRepresentable where RawValue: LosslessStringConvertible, Self: AppStorageConvertible {
    init?(_ storedValue: String) {
        guard let value = RawValue(storedValue) else { return nil }
        self.init(rawValue: value)
    }

    var storedValue: String {
        String(describing: rawValue)
    }
}

extension Array: AppStorageConvertible where Element: LosslessStringConvertible {
    public init?(_ storedValue: String) {
        let values = storedValue.components(separatedBy: ",")
        self = values.compactMap(Element.init)
    }

    var storedValue: String {
        return map(\.description).joined(separator: ",")
    }
}
