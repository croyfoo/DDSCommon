//
//  StaticMacro.swift
//  DDSCommon
//
//  Created by David Croy on 4/7/25.
//
import Foundation

@freestanding(expression)
public macro staticURL(_ value: StaticString) -> URL = #externalMacro(
    module: "DDSCommon",
    type: "StaticURLMacro"
)
