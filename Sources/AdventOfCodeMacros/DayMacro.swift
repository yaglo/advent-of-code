import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: - @Day Macro

public struct DayMacro: MemberMacro, ExtensionMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let members = declaration.memberBlock.members

    var hasDataInit = false
    var hasDefaultInit = false

    // Track which properties are declared
    var hasInput = false
    var hasLines = false
    var hasGrid = false

    for member in members {
      // Check for init declarations
      if let initDecl = member.decl.as(InitializerDeclSyntax.self) {
        let params = initDecl.signature.parameterClause.parameters
        if params.count == 1,
          let first = params.first,
          first.firstName.text == "data"
        {
          hasDataInit = true
        }
        if params.isEmpty {
          hasDefaultInit = true
        }
      }

      // Check for property declarations
      if let varDecl = member.decl.as(VariableDeclSyntax.self) {
        for binding in varDecl.bindings {
          if let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text {
            switch name {
            case "input": hasInput = true
            case "lines": hasLines = true
            case "grid": hasGrid = true
            default: break
            }
          }
        }
      }
    }

    var result: [DeclSyntax] = []

    if !hasDataInit {
      // Generate properties and init based on what's declared
      if hasInput {
        // User declared `let input: String`
        result.append("init(data: String) { self.input = data }")
      } else if hasLines {
        // User declared `let lines: [Substring]`
        result.append("init(data: String) { self.lines = data.lines() }")
      } else if hasGrid {
        // User declared `let grid: [[Character]]`
        result.append("init(data: String) { self.grid = data.mapLines { Array($0) } }")
      } else {
        // Default: generate `let data: String`
        result.append("let data: String")
        result.append("init(data: String) { self.data = data }")
      }
    }

    if !hasDefaultInit {
      result.append("init() { self.init(data: Self.loadData()) }")
    }

    return result
  }

  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    let ext = try ExtensionDeclSyntax("extension \(type): AdventDay { }")
    return [ext]
  }
}

@main
struct AdventOfCodeMacrosPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    DayMacro.self
  ]
}
