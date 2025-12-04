import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DayMacro: MemberMacro, ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return [
            "let data: String",
            "init(data: String) { self.data = data }",
            "init() { self.init(data: Self.loadData()) }",
        ]
    }

    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let ext = try ExtensionDeclSyntax("extension \(type): AdventDay, AdventDayTests { }")
        return [ext]
    }
}

@main
struct AdventOfCodeMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DayMacro.self
    ]
}
