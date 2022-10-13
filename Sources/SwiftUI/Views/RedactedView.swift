//
//  RedactedView.swift
//  Tes
//
//  https://www.swiftbysundell.com/tips/swiftui-automatic-placeholders/
//
//  Created by David Croy on 7/30/20.
//  Copyright © 2020 DoubleDog Software. All rights reserved.
//

import SwiftUI

struct RedactingView<Input: View, Output: View>: View {
    var content: Input
    var modifier: (Input) -> Output
    
    @Environment(\.redactionReasons) private var reasons
    
    var body: some View {
        if reasons.isEmpty {
            content
        } else {
            modifier(content)
        }
    }
}

extension View {
    func whenRedacted<T: View>(
        apply modifier: @escaping (Self) -> T
    ) -> some View {
        RedactingView(content: self, modifier: modifier)
    }
}
