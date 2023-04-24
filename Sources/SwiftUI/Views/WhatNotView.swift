//
//  SwiftUIView.swift
//  
//
//  Created by David Croy on 3/30/23.
//

import SwiftUI

struct WhatNotView<OffCircleContent: View, OnCircleContent: View, OffTrailingContent: View, OnTrailingContent: View>: View {
    @State var toggle: Bool = false
    @ScaledMetric var scale: CGFloat = 1
    var duration: TimeInterval = 0.6
    var thingHeight: CGFloat { scale * 33 }
    var stackSpacing: CGFloat { 6 }

    var animation: Animation {
        .spring()
    }
    
    private var offCircleContent: () -> (OffCircleContent)
    private var onCircleContent: () -> (OnCircleContent)
    private var offTrailingContent: () -> (OffTrailingContent)
    private var onTrailingContent: () -> (OnTrailingContent)
    
    init(
        @ViewBuilder offCircleContent: @escaping () -> (OffCircleContent),
        @ViewBuilder onCircleContent: @escaping () -> (OnCircleContent),
        @ViewBuilder offTrailingContent: @escaping () -> (OffTrailingContent),
        @ViewBuilder onTrailingContent: @escaping () -> (OnTrailingContent)
    ) {
        self.offCircleContent = offCircleContent
        self.onCircleContent = onCircleContent
        self.offTrailingContent = offTrailingContent
        self.onTrailingContent = onTrailingContent
    }
    
    var body: some View {
        HStack(spacing: stackSpacing) {
            // Use one circle for consistency, just fade in/out the content
            // Don't use transitions as they'll lose track of the underlying circle
            Circle()
                .foregroundColor(.clear)
                .overlay(circleContentOverlay, alignment: .leading)
                .clipShape(Circle())
            
            if toggle {
                onTrailingContent()
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity).animation(animation.delay(1/3)),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        )
                    )
            } else {
                offTrailingContent().transition(
                    .asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity).animation(animation.delay(1/3)),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    )
                )
            }
        }
        .frame(height: thingHeight, alignment: .leading)
        .padding(.trailing)
        .foregroundColor(.white)
        .fontDesign(.rounded)
        .fontWeight(.bold)
        .frame(alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 100, style: .circular))
        .clipped()
        .animation(animation, value: toggle)
        .onTapGesture {
            toggle.toggle()
        }
    }
    
    @ViewBuilder
    var circleContentOverlay: some View {
        Circle()
            .foregroundColor(.clear)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(alignment: .center, content: {
                ZStack(alignment: .center) {
                    onCircleContent()
                        .opacity(toggle ? 1 : 0)
                    offCircleContent()
                        .opacity(toggle ? 0 : 1)
                }
            })
            .frame(width: thingHeight, height: thingHeight, alignment: .leading)
    }
}

struct WhatNot_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Spacer()
                WhatNotView(
                    offCircleContent: {
                        Circle()
                            .scaledToFit()
                            .foregroundStyle(Color.red.gradient)
                            .overlay(
                                Image(systemName: "chart.bar.xaxis")
                            )
                    }, onCircleContent: {
                        Circle()
                            .scaledToFit()
                            .foregroundStyle(Color.yellow.gradient)
                            .overlay(
                                Text("🧑🏼‍💻")
                            )
                    }, offTrailingContent: {
                        Text("1.2k")
                            .foregroundColor(.primary)
                    }, onTrailingContent: {
                        Text("Alex is in this \(Text("live!").foregroundColor(.yellow))")
                            .foregroundColor(.primary)
                    }
                )
            }
            Spacer()
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}
