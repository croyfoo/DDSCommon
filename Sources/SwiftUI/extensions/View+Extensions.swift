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
    
    func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}

// MARK: -
// MARK: FLipRotate
@available(macOS 12.0, *)
public extension View {
    
    func flipRotate(_ degrees: Double) -> some View {
        rotation3DEffect(Angle(degrees: degrees), axis: (x: 0.0, y: 1.0, z: 0.0))
    }

//    @ViewBuilder
//    func placedOnCard(_ color: Color, width: CGFloat = 250, height: CGFloat = 150, alignment: Alignment = .center, corderRadius: CGFloat = 20) -> some View {
//        padding(5)
//            .frame(width: width, height: height, alignment: alignment)
//            .background(RoundedRectangle(cornerRadius: corderRadius).foregroundColor(color))
//    }
//
//    @available(macOS 12.0, *)
//    @ViewBuilder
//    func placedOnCard1(_ style: AnyShapeStyle, width: CGFloat = 250, height: CGFloat = 150, alignment: Alignment = .center, corderRadius: CGFloat = 20) -> some View {
//        padding(5)
//            .frame(width: width, height: height, alignment: alignment)
//            .background(style)
////            .background(RoundedRectangle(cornerRadius: corderRadius).foregroundColor(color))
//    }
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

// defines OptionSet, which corners to be rounded – same as UIRectCorner
public struct RectCorner: OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let topLeft     = RectCorner(rawValue: 1 << 0)
    static let topRight    = RectCorner(rawValue: 1 << 1)
    static let bottomRight = RectCorner(rawValue: 1 << 2)
    static let bottomLeft  = RectCorner(rawValue: 1 << 3)
    
    static let allCorners: RectCorner = [.topLeft, topRight, .bottomLeft, .bottomRight]
}


// draws shape with specified rounded corners applying corner radius
public struct RoundedCorner: Shape {
    
    var radius: CGFloat = .zero
    var corners: RectCorner = .allCorners
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let p1 = CGPoint(x: rect.minX, y: corners.contains(.topLeft) ? rect.minY + radius  : rect.minY )
        let p2 = CGPoint(x: corners.contains(.topLeft) ? rect.minX + radius : rect.minX, y: rect.minY )
        
        let p3 = CGPoint(x: corners.contains(.topRight) ? rect.maxX - radius : rect.maxX, y: rect.minY )
        let p4 = CGPoint(x: rect.maxX, y: corners.contains(.topRight) ? rect.minY + radius  : rect.minY )
        
        let p5 = CGPoint(x: rect.maxX, y: corners.contains(.bottomRight) ? rect.maxY - radius : rect.maxY )
        let p6 = CGPoint(x: corners.contains(.bottomRight) ? rect.maxX - radius : rect.maxX, y: rect.maxY )
        
        let p7 = CGPoint(x: corners.contains(.bottomLeft) ? rect.minX + radius : rect.minX, y: rect.maxY )
        let p8 = CGPoint(x: rect.minX, y: corners.contains(.bottomLeft) ? rect.maxY - radius : rect.maxY )
        
        
        path.move(to: p1)
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.minY),
                    tangent2End: p2,
                    radius: radius)
        path.addLine(to: p3)
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.minY),
                    tangent2End: p4,
                    radius: radius)
        path.addLine(to: p5)
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY),
                    tangent2End: p6,
                    radius: radius)
        path.addLine(to: p7)
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY),
                    tangent2End: p8,
                    radius: radius)
        path.closeSubpath()
        
        return path
    }
}

public extension View {
    func cornerRadius(_ radius: CGFloat, antialiased: Bool = true, corners: RectCorner) -> some View {
        clipShape(
            RoundedCorner(radius: radius, corners: corners)
        )
    }
    
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges)
            .foregroundColor(color))
    }
}
