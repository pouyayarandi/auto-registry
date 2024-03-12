// The Swift Programming Language
// https://docs.swift.org/swift-book

import Factory

public extension Container {
    public var coreLibrary: Factory<CoreLibrary> { self { fatalError() } }
}

public protocol CoreLibrary {
    func text() -> String
}
