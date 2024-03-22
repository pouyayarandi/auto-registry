// The Swift Programming Language
// https://docs.swift.org/swift-book

import Factory
import ServiceMacro

@Service
public protocol CoreLibrary {
    func text() -> String
}
