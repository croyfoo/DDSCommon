//
//  RecessedButtonStyle.swift
//  ControlRoom
//
//  Created by Dave DeLong on 2/19/20.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//sswiftlint:disable switch_case_alignment

import SwiftUI

struct RecessedButtonStyle: ButtonStyle {
    let edgeInsets: EdgeInsets
    static let defaultInsets = EdgeInsets(top: 1, leading: 6, bottom: 1, trailing: 6)

    init(_ edgeInsets: EdgeInsets = defaultInsets) {
        self.edgeInsets = edgeInsets
    }
    
    func makeBody(configuration: Configuration) -> some View {
        RecessedButton(isPressed: configuration.isPressed, label: configuration.label, edgeInsets: edgeInsets)//, isHovering: $isHovering)
    }
}

struct RecessedButton<Label: View>: View {
    let isPressed: Bool
    let label: Label
    let edgeInsets: EdgeInsets

    @State var isHovering: Bool = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.isEnabled) var isEnabled: Bool

    init(isPressed: Bool, label: Label, edgeInsets: EdgeInsets) { //}, isHovering: Binding<Bool>) {
        self.isPressed   = isPressed
        self.label       = label
        self.edgeInsets  = edgeInsets
    }
    
    var bgColor: Color {
        guard isEnabled else { return Color.normal }
        
        switch (colorScheme, isHovering, isPressed) {
            case (.dark, false, false): return Color.normal //Color(white: 0.0, opacity: 0.0)
            case (.dark, true, false): return Color.darkHover //Color(white: 1.0, opacity: 0.25)
            case (.dark, _, true): return Color.darkClicked //Color(white: 1.0, opacity: 0.4)

            case (_, false, false): return Color.normal //Color(white: 0.0, opacity: 0.0)
            case (_, true, false): return Color.lightHover //Color(white: 0.0, opacity: 0.25)
            case (_, _, true): return Color.lightClicked //Color(white: 0.0, opacity: 0.6)
        }
    }

    var fgColor: Color {
        guard isEnabled else { return Color.normal }

        switch (colorScheme, isHovering) {
            case (.dark, false): return Color.foregroundNormal
            case (.dark, true): return Color.foregroundDarkHover

            case (_, false): return Color.foregroundNormal
            case (_, true): return Color.foregroundLightHover
        }
    }

    var body: some View {
        label
            .padding(edgeInsets)
            .foregroundColor(fgColor)
            .background(RoundedRectangle(cornerRadius: 4).fill(bgColor).animation(.none))
            .onHover { inside in
                isHovering = inside
                if !isEnabled && inside {
                    NSCursor.operationNotAllowed.push()
                } else {
                    NSCursor.pop()
                }
            }
    }
}
