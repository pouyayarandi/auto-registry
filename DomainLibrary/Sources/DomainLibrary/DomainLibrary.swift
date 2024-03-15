// The Swift Programming Language
// https://docs.swift.org/swift-book

import Factory
import ServiceMacro

@Service(DomainLibrary.self)
public protocol DomainLibrary {
    func doSomething()
}
