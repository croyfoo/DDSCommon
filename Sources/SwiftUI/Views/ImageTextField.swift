//
//  ImageTextField.swift
//  SwiftUITests
//
//  Created by David Croy on 11/13/22.
//

import SwiftUI

extension View {
    
    func imgTextField(placeHolder: String = "", showPlaceHolder: Bool = true, height: CGFloat = 50, width: CGFloat = 250,
                      leadingImage: String) -> some View {
        modifier(ImageTextField(placeHolder: placeHolder, showPlaceHolder: showPlaceHolder, height: height, width: width, leadingImage: leadingImage))
    }
    
    func imgTextField(placeHolder: String = "", showPlaceHolder: Bool = true, height: CGFloat = 50, width: CGFloat = 250,
                      trailingImage: String) -> some View {
        modifier(ImageTextField(placeHolder: placeHolder, showPlaceHolder: showPlaceHolder, height: height, width: width, trailingImage: trailingImage))
    }
    
    func imgTextField(placeHolder: String = "", showPlaceHolder: Bool = true, height: CGFloat = 50, width: CGFloat = 250,
                      leadingImage: String, trailingImage: String) -> some View {
        modifier(ImageTextField(placeHolder: placeHolder, showPlaceHolder: showPlaceHolder, height: height, width: width, leadingImage: leadingImage, trailingImage: trailingImage))
    }
    
    func imgTextField(placeHolder: String = "", showPlaceHolder: Bool = true, height: CGFloat = 50, width: CGFloat = 250,
                      @ViewBuilder leadingImage: @escaping () -> some View) -> some View {
        modifier(ImageTextField(placeHolder: placeHolder, showPlaceHolder: showPlaceHolder, height: height, width: width, leadingImage: leadingImage))
    }
    
    func imgTextField(placeHolder: String = "", showPlaceHolder: Bool = true, height: CGFloat = 50, width: CGFloat = 250,
                      @ViewBuilder trailingImage: @escaping () -> some View) -> some View {
        modifier(ImageTextField(placeHolder: placeHolder, showPlaceHolder: showPlaceHolder, height: height, width: width, trailingImage: trailingImage))
    }
    
    func imgTextField(placeHolder: String = "", showPlaceHolder: Bool = true, height: CGFloat = 50, width: CGFloat = 250,
                      @ViewBuilder leadingImage: @escaping () -> some View,
                      @ViewBuilder trailingImage: @escaping () -> some View) -> some View {
        modifier(ImageTextField(placeHolder: placeHolder, showPlaceHolder: showPlaceHolder, height: height, width: width, leadingImage: leadingImage, trailingImage: trailingImage))
    }
}

struct ImageTextField<LeadingImage: View, TrailingImage: View>: ViewModifier {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let leadingImage: LeadingImage
    let trailingImage: TrailingImage
    let placeHolder: String
    let showPlaceHolder: Bool
    let height: CGFloat
    let width: CGFloat
    
    public init(placeHolder: String = "", showPlaceHolder: Bool = true, height: CGFloat = 50, width: CGFloat = 250, leadingImage: String) where LeadingImage == Image, TrailingImage == EmptyView {
        self.init(placeHolder: placeHolder, showPlaceHolder: showPlaceHolder, height: height, width: width) {
            Image(systemName: leadingImage)
        } trailingImage: {
            EmptyView()
        }
    }
    
    public init(placeHolder: String = "", showPlaceHolder: Bool = true, height: CGFloat = 50, width: CGFloat = 250, trailingImage: String) where LeadingImage == EmptyView, TrailingImage == Image {
        self.init(placeHolder: placeHolder, showPlaceHolder: showPlaceHolder, height: height, width: width) {
            EmptyView()
        } trailingImage: {
            Image(systemName: trailingImage)
        }
    }
    
    public init(placeHolder: String = "", showPlaceHolder: Bool = true, height: CGFloat = 50, width: CGFloat = 250, leadingImage: String, trailingImage: String) where LeadingImage == Image, TrailingImage == Image {
        self.init(placeHolder: placeHolder, showPlaceHolder: showPlaceHolder, height: height, width: width) {
            Image(systemName: leadingImage)
        } trailingImage: {
            Image(systemName: trailingImage)
        }
    }
    
    public init(placeHolder: String = "", showPlaceHolder: Bool = true, height: CGFloat = 50, width: CGFloat = 250, @ViewBuilder leadingImage: @escaping () -> LeadingImage) where TrailingImage == EmptyView {
        self.init(placeHolder: placeHolder, showPlaceHolder: showPlaceHolder, height: height, width: width, leadingImage: leadingImage, trailingImage: { EmptyView() } )
    }
    
    public init(placeHolder: String = "", showPlaceHolder: Bool = true, height: CGFloat = 50, width: CGFloat = 250, @ViewBuilder trailingImage: @escaping () -> TrailingImage) where LeadingImage == EmptyView {
        self.init(placeHolder: placeHolder, showPlaceHolder: showPlaceHolder, height: height, width: width, leadingImage: { EmptyView() }, trailingImage: trailingImage)
    }
    
    public init(placeHolder: String = "", showPlaceHolder: Bool = true,  height: CGFloat = 50, width: CGFloat = 250, @ViewBuilder leadingImage: @escaping () -> LeadingImage, @ViewBuilder trailingImage: @escaping () -> TrailingImage) {
        self.leadingImage  = leadingImage()
        self.trailingImage = trailingImage()
        self.placeHolder   = placeHolder
        self.showPlaceHolder = showPlaceHolder
        self.height = height
        self.width = width
    }
    
    func body(content: Content) -> some View {
        HStack {
            Spacer(minLength: 10)
            leadingImage
            content
                .textPlaceHolder(placeHolder: placeHolder, shouldShow: showPlaceHolder)
            trailingImage
            Spacer(minLength: 10)
        }
        .foregroundColor(colorScheme == .dark ? .white.opacity(0.75): .black)
        .placeOnCard(.regularMaterial, height: height, width: width, shadow: false, shadowRadius: 1)
    }
}
