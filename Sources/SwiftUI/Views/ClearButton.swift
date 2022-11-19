//
//  SwiftUIView.swift
//  
//
//  Created by David Croy on 11/3/22.
//

import SwiftUI

struct ImageButton: ViewModifier {
    @Binding var text: String
    let aligment: Alignment
    let imageName: String
    
    func body(content: Content) -> some View {
        HStack {
            if aligment == .trailing {
                content
                if !text.isEmpty {
                    imageButton()
//f                        .padding(.trailing, 8)
                }
            } else {
                imageButton()
                    .padding(.leading, 4)
                content
            }
        }
        .padding(6)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2))
    }
    
    @ViewBuilder
    func imageButton() -> some View {
            Button {
                text = ""
            } label: {
                Image(systemName: imageName)
            }
            .buttonStyle(.plain)
//            .focusable(false)
    }
}

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !text.isEmpty {
                imgButton()
                //                Button {
                //                    text = ""
                //                } label: {
                //                    if #available(macOS 12.0, *) {
                //                        Image(systemName: "delete.left")
                //                            .foregroundStyle(.gray)
                //                    } else {
                //                        Image(systemName: "delete.left")
                //                            .foregroundColor(.gray)
                //                    }
                //                }
                //                .buttonStyle(.plain)
                //                .padding(.trailing, 4)
                //            }
            }
        }
    }
    
    private func imgButton() -> some View {
        Button {
            text = ""
        } label: {
            if #available(macOS 12.0, *) {
                Image(systemName: "delete.left")
                    .foregroundStyle(.gray)
            } else {
                Image(systemName: "delete.left")
                    .foregroundColor(.gray)
            }
        }
        .buttonStyle(.plain)
        .padding(.trailing, 4)
    }
}

extension View {
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearButton(text: text))
    }

    func imageButton(text: Binding<String>, alignment: Alignment = .trailing, imageName: String = "delete.left" ) -> some View {
        modifier(ImageButton(text: text, aligment: alignment, imageName: imageName))
    }
}

struct ClearButton_Previews: PreviewProvider {
    @State var text: String
    static var previews: some View {
        VStack {
            StatefulPreviewWrapper("") {
                TextField("Enter something", text: $0)
                    .textFieldStyle(.plain)
                    .imageButton(text: $0, alignment: .trailing)
                    .padding()
            }
        }
        .frame(width: 200, height: 200)
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
