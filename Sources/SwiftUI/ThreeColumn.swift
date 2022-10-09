//
//  ThreeColumn.swift
//  FoldingText
//
//  Created by David Croy on 3/13/22.
//  Copyright © 2022 DoubleDog Software. All rights reserved.
//

import SwiftUI

struct ThreeColumn<Left: View, Center: View, Right: View>: View {
    
    var spacing: CGFloat
    let left: Left
    let center: Center
    let right: Right
    
    init(spacing: CGFloat = 8.0, @ViewBuilder left: () -> Left, @ViewBuilder center: () -> Center, @ViewBuilder right: () -> Right) {
        self.left    = left()
        self.center  = center()
        self.right   = right()
        self.spacing = spacing
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            left
                .frame(maxWidth: .infinity, alignment: .trailing)
            center
                .frame(maxWidth: .infinity, alignment: .leading)
            //                .foregroundColor(.black)
            //                .background(Color.yellow)
            right
                .frame(maxWidth: .infinity, alignment: .leading)
            //                .foregroundColor(.black)
            //                .background(Color.yellow)
        }
    }
}

struct ThreeColumn_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 8.0) {
                ThreeColumn {
                    Text("Left")
                        .border(Color.white)
                } center: {
                    Text("Center")
                        .frame(alignment: .leading)
                } right: {
                    Text("Right")
                        .border(Color.red)
                    
                }
                ThreeColumn {
                    Text("Left sdfasdfasd")
                        .border(Color.white)
                } center: {
                    Text("Center asdfa")
                        .border(Color.blue)
                } right: {
                    Text("Right sdfsdf")
                        .border(Color.red)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            //            .background(Color.red)
        }
        .frame(width: 300, height: 100)
    }
}
