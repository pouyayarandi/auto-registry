// The Swift Programming Language
// https://docs.swift.org/swift-book

import Factory
import ServiceMacro

// sourcery: imp-module = DomainLibrary_Imp
@Service
public protocol DomainLibrary {
    func doSomething()
}
