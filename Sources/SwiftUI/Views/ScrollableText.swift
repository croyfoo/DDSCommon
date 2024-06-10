//
//  ScrollableTextView.swift
//  FlashCards
//
//  Created by David Croy on 5/9/24.
//

import SwiftUI

public struct ScrollableText: View {
  let text: String
  let alignment: Alignment
  
  public init(_ text: String, alignment: Alignment = .center) {
    self.text      = text
    self.alignment = alignment
  }
  
  public var body: some View {
    ScrollView {
      VStack {
        Text(text)
          .textSelection(.enabled)
          .lineLimit(nil)
      }
      .textSelection(.enabled)
      .frame(maxWidth: .infinity, alignment: alignment)
    }
  }
}

#Preview {
  ScrollableText("[First Name] just like you, online reputation")
//    ScrollableText("[First Name] just like you, online reputation is important to me too, and that's exactly how I found Momentum. Once I knew solar was the industry for me, I did a ton of research to find a company that shared my values and operated with integrity. I wanted a company that stood behind their work and was a place where I could have a long-term career. In my research I found the one thing all lasting great organizations had in common was great leadership… and this is what led me to Momentum. I learned that our CEO, Arthur Souritzidis, received Forbes’ 30 under 30 award in the renewable energy sector. That's Forbes recognizing him for being one of the best business minds in the industry and for bringing a “customer-first” approach to solar. And Sung Lee, his business partner and CFO, is a Harvard MBA and West Point graduate. He spent 10 years in the Army and then another 10 with Morgan Stanley as their solar industry expert. Sung left the prestige and security of that position to join Momentum, so I knew he was certain about the long-term future of this company.")
    .padding()
    .addBorder(.red, cornerRadius: 10)
    .font(.title)
    .padding()
}
