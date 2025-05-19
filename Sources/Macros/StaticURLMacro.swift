//
//  Untitled.swift
//  DDSCommon
//
//  Created by David Croy on 4/7/25.
//
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

enum StaticURLMacroError: String, Error, CustomStringConvertible {
  case notAStringLiteral = "Argument is not a string literal"
  case invalidURL        = "Argument is not a valid URL"
  
  public var description: String { rawValue }
}

public struct StaticURLMacro: ExpressionMacro {
  public static func expansion( of node: some FreestandingMacroExpansionSyntax,
                                in context: some MacroExpansionContext ) throws -> ExprSyntax {
    // CHANGE: Update to use argumentList instead of arguments
    guard let argument = node.argumentList.first?.expression,
          let stringLiteral = argument.as(StringLiteralExprSyntax.self),
          case .stringSegment(let segment) = stringLiteral.segments.first
    else {
      throw StaticURLMacroError.notAStringLiteral
    }
    
    guard URL(string: segment.content.text) != nil else {
      throw StaticURLMacroError.invalidURL
    }
    
    return "Foundation.URL(string: \(argument))!"
  }
}

//@main struct StaticURLPlugin: CompilerPlugin {
//  let providingMacros: [Macro.Type] = [StaticURLMacro.self]
//}
