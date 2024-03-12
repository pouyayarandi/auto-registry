// The Swift Programming Language
// https://docs.swift.org/swift-book

import Factory
import ServiceMacro

public protocol CoreLibrary {
    func text() -> String
}

@ServiceAPI("CoreLibrary")
extension Container {}