// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: arbitrary)
public macro Service(_: Any) = #externalMacro(module: "ServiceMacroMacros", type: "ServiceAPIMacro")
