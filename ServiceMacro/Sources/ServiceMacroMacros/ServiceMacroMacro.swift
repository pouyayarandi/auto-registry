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
            "public var \(raw: arg.camelcased()): Factory<\(raw: arg)> { self { fatalError() } }",
        ]
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
    ]
}
