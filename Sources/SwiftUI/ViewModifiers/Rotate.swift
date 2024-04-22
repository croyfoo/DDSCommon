//
//  RotateImage.swift
//  FinancialT
//
//  Created by David Croy on 9/13/23.
//

import Foundation
import SwiftUI

public struct Rotate: ViewModifier {
    @State private var degrees: Double
    private let startDegrees: Double
    private let rotationDegres: Double
    private let gesture: any Gesture
    
    public init(_ startDegrees: Double = -90.0, gesture: any Gesture = TapGesture()) {
        self.startDegrees   = startDegrees
        self._degrees       = State(initialValue: startDegrees)
        self.rotationDegres = startDegrees - 360
        self.gesture        = gesture
    }
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(degrees))
//            .gesture(
//                (self.gesture as Gesture)
//                self.gesture { _ in
//                    withAnimation(.easeIn(duration: 0.5)) {
//                        degrees = (degrees == rotationDegres) ? startDegrees : rotationDegres
//                    }
//                }
//            )
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.5)) {
                    degrees = (degrees == rotationDegres) ? startDegrees : rotationDegres
                }
            }
    }
}

public extension View {
    func rotate(_ startDegrees: Double = -90) -> some View {
        self.modifier(Rotate(startDegrees))
    }
}

#Preview {
    Text("Hello, World!")
        .rotate()
}
