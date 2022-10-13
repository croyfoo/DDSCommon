// Original article here: https://www.fivestars.blog/code/redacted-custom-effects.html
//  RedactableView.swift
//  Tes
//
//  Created by David Croy on 7/30/20.
//  Copyright © 2020 DoubleDog Software. All rights reserved.
//

import SwiftUI

public enum RedactionReason {
    case placeholder
    case confidential
    case blurred
}

// MARK: Step 2: Define Modifiers
struct Placeholder: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 14.0, macOS 11.0, *) {
            content.redacted(reason: RedactionReasons.placeholder)
//        } else {
//            content
//                .accessibility(label: Text("Placeholder"))
//                .opacity(0)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 2)
//                        .fill(Color.black.opacity(0.1))
//                        .padding(.vertical, 4.5)
//                )
        }
    }
}

struct Confidential: ViewModifier {
    func body(content: Content) -> some View {
        content
            .accessibility(label: Text("Confidential", comment: "Label: Confidential"))
            .opacity(0)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.black.opacity(1))
                    .padding(.vertical, 4.5)
            )
    }
}

struct Blurred: ViewModifier {
    var radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .accessibility(label: Text("blurred", comment: "Text: Blured text"))
            .blur(radius: radius)
    }
}

// MARK: Step 3: Define RedactableView
struct RedactableView: ViewModifier {
    let reason: RedactionReason?
    let radius: CGFloat
    
    @ViewBuilder
    func body(content: Content) -> some View {
        switch reason {
        case .placeholder:
            content
                .modifier(Placeholder())
        case .confidential:
            content
                .modifier(Confidential())
        case .blurred:
            content
                .modifier(Blurred(radius: radius))
        case nil:
            content
        }
    }
}

// MARK: Step 4: Define View Extension
extension View {
    func redacted(reason: RedactionReason?, r: CGFloat = 4) -> some View {
        self
            .modifier(RedactableView(reason: reason, radius: r))
    }
}

//struct RedactableView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            Text("Hello World")
//                .redacted(reason: nil)
//            Text("Hello World")
//                .redacted(reason: .confidential)
//            Text("Hello World sdfasdfasdf asdfasdasdfasd")
//                .redacted(reason: .placeholder)
//            Text("Hello World")
//                .redacted(reason: .blurred)
//            Image(systemName: "star")
//                .redacted(reason: .placeholder)
//        }
//        .font(.title)
//        .frame(width: 300, height: 200, alignment: .center)
//    }
//}
