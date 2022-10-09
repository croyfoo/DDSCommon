//
//  StringProtocol+Ext.swift
//  Tes
//
//  Created by David Croy on 7/29/21.
//  Copyright © 2021 DoubleDog Software. All rights reserved.
//

import Foundation

extension StringProtocol {
    var wordCount: Int {
        words.count
    }
    
    var byWordsCount: Int {
        byWords.count
    }
    
    var words: [SubSequence] {
        split { !$0.isLetter }
    }
    
    var characterCount: Int {
        byComposedCharacterSequence.count
    }
    
    var byWords: [SubSequence] {
        subStrings()
    }
    
    var byParagraphs: [SubSequence] {
        subStrings(options: .byParagraphs)
    }
    
    var byParagraphsCount: Int {
        byParagraphs.count
    }
    
    var byComposedCharacterSequence: [SubSequence] {
        subStrings(options: .byComposedCharacterSequences)
    }
    
    var lineCount: Int {
        split { $0.isNewline }.count
    }
    
    private func subStrings(options: String.EnumerationOptions = .byWords) -> [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: options) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
    

}
