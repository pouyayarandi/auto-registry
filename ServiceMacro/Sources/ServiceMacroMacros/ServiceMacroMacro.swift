import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ServiceAPIMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        if node.description.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "") != node.description.trimmingCharacters(in: .whitespacesAndNewlines) {
            fatalError("Use no whitespace in @Service argument")
        }
        guard case .argumentList(let args) = node.arguments, let arg = args.first else {
            fatalError("Argument is not valid")
        }
        let name = arg.description.replacingOccurrences(of: ".self", with: "")
        return [
            "public var \(raw: name.camelcased()): Factory<\(raw: name)> { self { fatalError() } }",
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
