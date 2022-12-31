//
//  File.swift
//  
//
//  Created by David Croy on 12/21/22.
//
// https://betterprogramming.pub/swiftui-binding-extensions-b6a9f27d2858

import Foundation
import SwiftUI

// @StateObject var viewModel = SomeViewModel()
// TextField("Name", text: $viewModel.name.defaultValue(""))
extension Binding {
    public func defaultValue<T>(_ value: T) -> Binding<T> where Value == Optional<T> {
        Binding<T> {
            wrappedValue ?? value
        } set: {
            wrappedValue = $0
        }
    }
}


// @StateObject var viewModel = SomeViewModel()
// TextField("Name", text: $viewModel.name.orEmpty)
extension Binding where Value == Optional<String> {
    public var orEmpty: Binding<String> {
        Binding<String> {
            wrappedValue ?? ""
        } set: {
            wrappedValue = $0
        }
    }
}

//struct AmazinglyComplexView_Previews: PreviewProvider {
//    static var previews: some View {
//        AmazinglyComplexView(value: .variable(true))
//    }
//}
extension Binding {
    public static func variable(_ value: Value) -> Binding<Value> {
        var state = value
        return Binding<Value> {
            state
        } set: {
            state = $0
        }
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Bindings2(true, "Mike") {
//            AnotherComplexView(value: $0, name: $1)
//        }
//    }
//}
struct Bindings2<V0, V1, Content:View>: View {
    @State var v0: V0
    @State var v1: V1
    let content: (_ v0: Binding<V0>, _ v1: Binding<V1>) -> Content
    init(_ v0: V0, _ v1: V1, @ViewBuilder content: @escaping (_ v0: Binding<V0>, _ v1: Binding<V1>) -> Content) {
        _v0 = .init(initialValue: v0)
        _v1 = .init(initialValue: v1)
        self.content = content
    }
    var body: some View {
        content($v0, $v1)
    }
}

struct Bindings3<V0, V1, V2, Content: View>: View {
    @State var v0: V0
    @State var v1: V1
    @State var v2: V2
    let content: (_ v0: Binding<V0>, _ v1: Binding<V1>, _ v2: Binding<V2>) -> Content
    init(_ v0: V0, _ v1: V1, _ v2: V2,
         @ViewBuilder content: @escaping (_ v0: Binding<V0>, _ v1: Binding<V1>, _ v2: Binding<V2>) -> Content) {
        _v0 = .init(initialValue: v0)
        _v1 = .init(initialValue: v1)
        _v2 = .init(initialValue: v2)
        self.content = content
    }
    var body: some View {
        content($v0, $v1, $v2)
    }
}

struct Bindings4<V0, V1, V2, V3, Content: View>: View {
    @State var v0: V0
    @State var v1: V1
    @State var v2: V2
    @State var v3: V3
    let content: (_ v0: Binding<V0>, _ v1: Binding<V1>, _ v2: Binding<V2>, _ v3: Binding<V3>) -> Content
    init(_ v0: V0, _ v1: V1, _ v2: V2, _ v3: V3,
         @ViewBuilder content: @escaping (_ v0: Binding<V0>, _ v1: Binding<V1>, _ v2: Binding<V2>, _ v3: Binding<V3>) -> Content) {
        _v0 = .init(initialValue: v0)
        _v1 = .init(initialValue: v1)
        _v2 = .init(initialValue: v2)
        _v3 = .init(initialValue: v3)
        self.content = content
    }
    var body: some View {
        content($v0, $v1, $v2, $v3)
    }
}


//struct AmazinglyComplexView_Previews: PreviewProvider {
//    static var previews: some View {
//        StateWrapper(value: true) {
//            AmazinglyComplexView(value: $0)
//        }
//    }
//}
struct StateWrapper<Value, Content:View>: View {
    @State var value: Value
    let content: (_ value: Binding<Value>) -> Content
    init(value: Value, @ViewBuilder content: @escaping (_ value: Binding<Value>) -> Content) {
        _value = .init(initialValue: value)
        self.content = content
    }
    var body: some View {
        content($value)
    }
}
