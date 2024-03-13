import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ServiceAPIMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard case .argumentList(let args) = node.arguments,
                let arg = args.first?.expression.description.replacingOccurrences(of: ".self", with: "") else {
            fatalError("Arguments are not correct")
        }
        return [
            "public var \(raw: arg): Factory<\(raw: arg)> { self { fatalError() } }",
        ]
    }
}

@main
struct ServiceMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ServiceAPIMacro.self,
    ]
}
