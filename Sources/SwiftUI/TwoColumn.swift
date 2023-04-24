//
//  TwoColumn.swift
//  Tes
//
//  Created by David Croy on 7/7/21.
//  Copyright © 2021 DoubleDog Software. All rights reserved.
//

import SwiftUI

public struct TwoColumn<Leading: View, Trailing: View>: View {
    
    var spacing: CGFloat
    let leading: Leading
    let trailing: Trailing
    let leadingAlignment: Alignment
    let trailingAlignment: Alignment
    let alignment: VerticalAlignment
    let maxWidth: CGFloat
    
    public init(spacing: CGFloat = 8.0, alignment: VerticalAlignment = .center, leadingAlignment: Alignment = .trailing, trailingAlignment: Alignment = .leading, maxWidth: CGFloat = .infinity, @ViewBuilder leading: () -> Leading, @ViewBuilder trailing: () -> Trailing) {
        self.leading            = leading()
        self.trailing           = trailing()
        self.spacing            = spacing
        self.leadingAlignment   = leadingAlignment
        self.trailingAlignment  = trailingAlignment
        self.alignment          = alignment
        self.maxWidth           = maxWidth
    }
    
    public var body: some View {
        HStack(alignment: alignment, spacing: spacing) {
            prepareSubview(leading, alignment: leadingAlignment)
            prepareSubview(trailing, alignment: trailingAlignment)
        }
    }
    
    private func prepareSubview( _ view: some View, alignment: Alignment) -> some View {
        view.frame(maxWidth: maxWidth, maxHeight: .infinity, alignment: alignment)
    }
}

struct TwoColumn_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack {
                TwoColumn {
                    Text("foo")
                        .padding(3)
                        .border(Color.white)
                } trailing: {
                    Text("Bar")
                        .padding(3)
                        .border(Color.white)
                }
                TwoColumn {
                    Text("cat")
                } trailing: {
                    Text("dogdddd")
                }
            }
            .border(Color.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.red)
        }
//        .frame(width: 200, height: 100)
        .border(Color.blue)
        .padding()
    }
}
