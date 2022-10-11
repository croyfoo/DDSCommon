//
//  View+Extensions.swift
//  FoldingText
//
//  Created by David Croy on 3/26/22.
//

import SwiftUI

public extension View {
    func transparentBox(_ opacity: Double = 0.2, cornerRadius: CGFloat = 10, alignment: Alignment = .leading, maxWidth: CGFloat = .zero, color: Color = Color.backgroundColor) -> some View {
        self
//            .padding()
            .if (maxWidth != .zero) { view in
                view.frame(maxWidth: maxWidth, alignment: alignment)
            }
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color.opacity(opacity))
            )
    }
    
    func transparentBoxWithShadow(_ opacity: Double = 0.2, cornerRadius: CGFloat = 10, shadowRadius: CGFloat = 10) -> some View {
        self
//            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.backgroundColor.opacity(opacity))
            )
            .clipped()
            .shadow(radius: shadowRadius)
    }

    @ViewBuilder
    func redacted(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
    }
}

// MARK: -
// MARK: FLipRotate
public extension View {
    
    func flipRotate(_ degrees: Double) -> some View {
        return rotation3DEffect(Angle(degrees: degrees), axis: (x: 0.0, y: 1.0, z: 0.0))
    }
    
    func placedOnCard(_ color: Color) -> some View {
        return padding(5).frame(width: 250, height: 150, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(color))
    }
}

// MARK: -
// MARK: View Debug Utilities
public extension View {
    
    func debugAction(_ closure: () -> Void) -> Self {
#if DEBUG
        closure()
#endif
        
        return self
    }
    
    func debugPrint(_ value: Any) -> Self {
        debugAction { print(value) }
    }
    
    func debugModifier<T: View>(_ modifier: (Self) -> T) -> some View {
#if DEBUG
        return modifier(self)
#else
        return self
#endif
    }
    
    func debugBorder(_ color: Color = .red, width: CGFloat = 1) -> some View {
        debugModifier {
            $0.border(color, width: width)
        }
    }
    
    func debugBackground(_ color: Color = .red) -> some View {
        debugModifier {
            $0.background(color)
        }
    }
}

// MARK: -
// MARK: Conditional View Modifiler
public extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
    //    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    //        if condition {
    //            transform(self)
    //        } else {
    //            self
    //        }
    //    }
}

public extension View {
    func centerHorizontally() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
    
    func centerVertically() -> some View {
        VStack {
            Spacer()
            self
            Spacer()
        }
    }

    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
}

public extension ShapeStyle where Self == Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
