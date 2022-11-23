//
//  View+Extensions.swift
//  FoldingText
//
//  Created by David Croy on 3/26/22.
//

import SwiftUI

public extension View {
    
    func transparentBox(_ opacity: Double = 0.2, cornerRadius: CGFloat = 10, alignment: Alignment = .leading, maxWidth: CGFloat = .zero, color: Color = Color.backgroundColor, padding: CGFloat? = nil, border: Bool = false, borderColor: Color = .clear, shadow: Bool = false, shadowRadius: CGFloat = 10) -> some View {
        self
            .if (padding != nil ) { view in
                view.padding(padding!)
            }
            .if (maxWidth != .zero) { view in
                view.frame(maxWidth: maxWidth, alignment: alignment)
            }
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)//.fill(.blue.opacity(0.2))
                    .strokeBorder( border ? (borderColor == .clear ? color : borderColor) : .clear)
                    .background(RoundedRectangle(cornerRadius: cornerRadius).fill(color.opacity(opacity)))
            )
            .if(shadow) { view in
                view.clipped()
                    .shadow(radius: shadowRadius)
            }
    }
    
    func transparentBoxWithShadow(_ opacity: Double = 0.2, cornerRadius: CGFloat = 10, shadowRadius: CGFloat = 10) -> some View {
        self
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.backgroundColor.opacity(opacity))
            )
            .clipped()
            .shadow(radius: shadowRadius)
    }

    @ViewBuilder
    func redacted(if condition: @autoclosure () -> Bool, reason: RedactionReasons = .placeholder) -> some View {
        redacted(reason: condition() ? reason : [])
    }
}

// MARK: -
// MARK: FLipRotate
@available(macOS 12.0, *)
public extension View {
    
    func flipRotate(_ degrees: Double) -> some View {
        rotation3DEffect(Angle(degrees: degrees), axis: (x: 0.0, y: 1.0, z: 0.0))
    }
    
    @ViewBuilder
    func placedOnCard(_ color: Color, width: CGFloat = 250, height: CGFloat = 150, alignment: Alignment = .center, corderRadius: CGFloat = 20) -> some View {
        padding(5)
            .frame(width: width, height: height, alignment: alignment)
            .background(RoundedRectangle(cornerRadius: corderRadius).foregroundColor(color))
    }

    @available(macOS 12.0, *)
    @ViewBuilder
    func placedOnCard1(_ style: AnyShapeStyle, width: CGFloat = 250, height: CGFloat = 150, alignment: Alignment = .center, corderRadius: CGFloat = 20) -> some View {
        padding(5)
            .frame(width: width, height: height, alignment: alignment)
            .background(style)
//            .background(RoundedRectangle(cornerRadius: corderRadius).foregroundColor(color))
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


// MARK: - Circular Image Modifier
public extension View {
    func profileImage() -> some View {
        ModifiedContent(content: self, modifier: CircularSpinnyImageModifier())
    }
}

struct Show: ViewModifier {
    let isVisible: Bool
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if isVisible {
            content
        } else {
            content.hidden()
        }
    }
}

public extension View {
    func show(isVisible: Bool) -> some View {
        ModifiedContent(content: self, modifier: Show(isVisible: isVisible))
    }
}

