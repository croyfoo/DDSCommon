//
//  TwoColumn.swift
//  Tes
//
//  Created by David Croy on 7/7/21.
//  Copyright © 2021 DoubleDog Software. All rights reserved.
//

import SwiftUI

struct TwoColumn<Left: View, Right: View>: View {
    
    var spacing: CGFloat
    let left: Left
    let right: Right
    let leftAlignment: Alignment
    let rightAlignment: Alignment
    
    init(spacing: CGFloat = 8.0, leftAlignment: Alignment = .trailing, rightAlignment: Alignment = .leading, @ViewBuilder left: () -> Left, @ViewBuilder right: () -> Right) {
        self.left           = left()
        self.right          = right()
        self.spacing        = spacing
        self.leftAlignment  = leftAlignment
        self.rightAlignment = rightAlignment
    }
    var body: some View {
        HStack(spacing: spacing) {
            left
                .frame(maxWidth: .infinity, alignment: leftAlignment)
            //                .foregroundColor(.black)
            //                .background(Color.yellow)
            right
                .frame(maxWidth: .infinity, alignment: rightAlignment)
            //                .foregroundColor(.black)
            //                .background(Color.yellow)
        }
    }
}

struct TwoColumn_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 8.0) {
                TwoColumn {
                    Text("foo")
                } right: {
                    Text("Bar")
                }
                TwoColumn {
                    Text("cat")
                } right: {
                    Text("dogdddd")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.red)
        }
        .frame(width: 200, height: 100)
    }
}
