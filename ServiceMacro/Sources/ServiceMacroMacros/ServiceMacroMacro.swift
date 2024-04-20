import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct BuildError: Error, CustomStringConvertible {
    let message: String
    var description: String { message }
}

public struct ServiceAPIMacro: PeerMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard let proto = declaration.as(ProtocolDeclSyntax.self) else {
            throw BuildError(message: "Service must be protocol")
        }
        let name = proto.name.trimmed
        return ["""
                final public class \(raw: name)_Container: SharedContainer {
                    public var manager: ContainerManager = .init()
                    public static var shared: \(raw: name)_Container = .init()
                    public var \(raw: name.text.camelcased()): Factory<\(raw: name)> {
                        self { fatalError() }
                    }
                }
                """]
    }
}

public struct ServiceImplementationMacro: PeerMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard case .argumentList(let args) = node.arguments, let arg = args.first else {
            throw BuildError(message: "Some arguments may be invalid")
        }
        let apiName = arg.description.replacingOccurrences(of: ".self", with: "")
        guard let impName = declaration.as(StructDeclSyntax.self)?.name ?? declaration.as(ClassDeclSyntax.self)?.name else {
            throw BuildError(message: "Implementation must be either class or struct")
        }
        guard impName.text == "\(apiName)_Imp" else {
            throw BuildError(message: "Implementation name should be <ServiceName>_Imp")
        }
        return ["""
                public struct \(raw: impName)_Registry {
                    public static func register(_ container: \(raw: apiName)_Container = .shared) {
                        container.\(raw: apiName.camelcased()).register {
                            \(raw: impName.trimmed)()
                        }
                    }
                }
                """]
    }
}

extension String {
    func camelcased() -> String {
        guard !isEmpty else { return self }
        return first!.lowercased() + self.dropFirst()
    }
}

@main
struct ServiceMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ServiceAPIMacro.self,
        ServiceImplementationMacro.self,
    ]
}
