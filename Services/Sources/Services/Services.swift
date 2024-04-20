// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(peer, names: suffixed(_Container))
public macro Service() = #externalMacro(module: "ServicesMacros", type: "ServiceAPIMacro")

@attached(peer, names: suffixed(_Registry))
public macro Implementation(_: Any) = #externalMacro(module: "ServicesMacros", type: "ServiceImplementationMacro")
