// The Swift Programming Language
// https://docs.swift.org/swift-book

import Factory
import ServiceMacro

public protocol DomainLibrary {
    func doSomething()
}

@Service(DomainLibrary.self)
extension Container {}
