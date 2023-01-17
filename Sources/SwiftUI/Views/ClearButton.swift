//
//  SwiftUIView.swift
//  
//
//  Created by David Croy on 11/3/22.
//

import SwiftUI

//struct ImageButton: ViewModifier {
//    @Binding var text: String
//    let aligment: Alignment
//    let imageName: String
//
//    func body(content: Content) -> some View {
//        HStack {
//            if aligment == .trailing {
//                content
//                if !text.isEmpty {
//                    imageButton()
//                }
//            } else {
//                imageButton()
//                    .padding(.leading, 4)
//                content
//            }
//        }
//        .padding(6)
//        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2))
//    }
//
//    @ViewBuilder
//    func imageButton() -> some View {
//            Button {
//                text = ""
//            } label: {
//                Image(systemName: imageName)
//            }
//            .buttonStyle(.plain)
////            .focusable(false)
//    }
//}

struct ImageButton<Img: View>: ViewModifier {
    let aligment: Alignment
    let image: Img
    
    public init(_ alignment: Alignment, @ViewBuilder img: @escaping () -> Img) {
        self.aligment = alignment
        self.image    = img()
    }
    
    func body(content: Content) -> some View {
        HStack {
            if aligment == .trailing {
                content
                image
                    .padding(.trailing, aligment == .trailing ? 5: 0)
            } else {
                image
                    .padding(.leading, 4)
                content
            }
        }
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2))
    }
    
//    @ViewBuilder
//    func imageButton() -> some View {
//        Button {
//            text = ""
//        } label: {
//            Image(systemName: imageName)
//        }
//        .buttonStyle(.plain)
//        //            .focusable(false)
//    }
}

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !text.isEmpty {
                imgButton()
            }
        }
    }
    
    private func imgButton() -> some View {
        Button {
            text = ""
        } label: {
            Image(systemName: "delete.left")
                .backport.foregroundStyle(.gray)
        }
        .buttonStyle(.plain)
        .padding(.trailing, 4)
    }
}

public extension View {
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearButton(text: text))
    }

//    public func imageButton(text: Binding<String>, alignment: Alignment = .trailing, imageName: String = "delete.left" ) -> some View {
//        modifier(ImageButton(text: text, aligment: alignment, imageName: imageName))
//    }
    func imageButton(_ alignment: Alignment = .trailing, @ViewBuilder leadingImage: @escaping () -> some View) -> some View {
        modifier(ImageButton(alignment, img: leadingImage))
    }
}

struct ClearButton_Previews: PreviewProvider {
    @State var text: String
    static var previews: some View {
        VStack {
            StatefulPreviewWrapper("") {
                TextField("Enter something", text: $0)
                    .textFieldStyle(.plain)
                    .padding(5)
//                    .imageButton(.trailing) {
//                        Image(systemName: "delete.left")
//                            .padding(.trailing, 5)
//                    }
                    .imageButton(.trailing) {
                        Image(systemName: "magnifyingglass")
                    }
                    .padding()
            }
        }
        .frame(width: 300, height: 200)
    }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content
    
    var body: some View {
        content($value)
    }
    
    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}
