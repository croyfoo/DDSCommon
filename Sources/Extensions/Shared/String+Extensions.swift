//
//  File.swift
//
//
//  Created by David Croy on 3/14/22.
//

import Foundation
import NaturalLanguage

let stopWords: [String] = ["i", "me", "my", "myself", "we", "our", "ours",
                           "ourselves", "you", "your", "yours", "yourself", "yourselves", "he", "him",
                           "his", "himself", "she", "her", "hers", "herself", "it", "its", "itself",
                           "they", "them", "their", "theirs", "themselves", "what", "which", "who",
                           "whom", "this", "that", "these", "those", "am", "is", "are", "was", "were",
                           "be", "been", "being", "have", "has", "had", "having", "do", "does", "did",
                           "doing", "a", "an", "the", "and", "but", "if", "or", "because", "as", "until",
                           "while", "of", "at", "by", "for", "with", "about", "against", "between",
                           "into", "through", "during", "before", "after", "above", "below", "to",
                           "from", "up", "down", "in", "out", "on", "off", "over", "under", "again",
                           "further", "then", "once", "here", "there", "when", "where", "why", "how",
                           "all", "any", "both", "each", "few", "more", "most", "other", "some", "such",
                           "no", "nor", "not", "only", "own", "same", "so", "than", "too", "very", "s",
                           "t", "can", "will", "just", "don", "should", "now"]

public extension String {
  
  enum TrimmingOptions {
    case all
    case leading
    case trailing
    case leadingAndTrailing
  }
  
  func trimming(spaces: TrimmingOptions, using characterSet: CharacterSet = .whitespacesAndNewlines) ->  String {
    switch spaces {
      case .all: return trimmingAllSpaces(using: characterSet)
      case .leading: return trimingLeadingSpaces(using: characterSet)
      case .trailing: return trimingTrailingSpaces(using: characterSet)
      case .leadingAndTrailing:  return trimmingLeadingAndTrailingSpaces(using: characterSet)
    }
  }
  
  func trimmingPuctuationCharacters() -> String {
    self.trimming(spaces: .all, using: .punctuationCharacters)
  }
  
  private func trimingLeadingSpaces(using characterSet: CharacterSet) -> String {
    guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
      return self
    }
    
    return String(self[index...])
  }
  
  private func trimingTrailingSpaces(using characterSet: CharacterSet) -> String {
    guard let index = lastIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: characterSet) }) else {
      return self
    }
    
    return String(self[...index])
  }
  
  private func trimmingLeadingAndTrailingSpaces(using characterSet: CharacterSet) -> String {
    return trimmingCharacters(in: characterSet)
  }
  
  private func trimmingAllSpaces(using characterSet: CharacterSet) -> String {
    return components(separatedBy: characterSet).joined()
  }
  
  func preparForNLP(lemmatize: Bool = true) -> String {
    let wordSet = NSMutableOrderedSet(array: trimmingPuctuationCharacters().lowercased().byWords)
    wordSet.minus(NSOrderedSet(array: stopWords))
    let arr = wordSet.array.compactMap { $0 as? String }
    
    let str = arr.joined(separator: " ")
    return lemmatize ? str.lemmatized() : str
  }
  
  func lemmatized() -> String {
    let tagger = NLTagger(tagSchemes: [.lemma])
    tagger.string = self
      
    var result = [String]()
    
    tagger.enumerateTags(in: self.startIndex..<self.endIndex, unit: .word, scheme: .lemma) { tag, tokenRange in
      let stemForm = tag?.rawValue ?? String(self[tokenRange])
      result.append(stemForm)
      return true
    }
      
    return result.joined()
  }
}

public extension String {
  
  var length: Int {
    count
  }
  
  subscript (i: Int) -> String {
    self[i ..< i + 1]
  }
  
  func substring(fromIndex: Int) -> String {
    self[min(fromIndex, length) ..< length]
  }
  
  func substring(toIndex: Int) -> String {
    self[0 ..< max(0, toIndex)]
  }
  
  subscript (r: Range<Int>) -> String {
    let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                        upper: min(length, max(0, r.upperBound))))
    let start = index(startIndex, offsetBy: range.lowerBound)
    let end = index(start, offsetBy: range.upperBound - range.lowerBound)
    return String(self[start ..< end])
  }
}

// MARK: -
public extension String {
  
  var shaString: String {
    self.data(using: .utf8)!.shaString
  }
  
  /// An MD5 hash of the string's UTF-8 representation.
  //    var md5Hash: Data {
  //        self.data(using: .utf8)!.md5Hash
  //    }
  //
  //    /// A hexadecimal representaion of an MD5 hash of the string's UTF-8 representation.
  //    var md5String: String {
  //        self.md5Hash.hexadecimalString!
  //    }
}

// MARK: -
// MARK: Version Compare
/// https://sarunw.com/posts/how-to-compare-two-app-version-strings-in-swift/
public extension String {
  
  func versionCompare(_ otherVersion: String) -> ComparisonResult {
    let versionDelimiter = "."
    
    var versionComponents = self.components(separatedBy: versionDelimiter) // <1>
    var otherVersionComponents = otherVersion.components(separatedBy: versionDelimiter)
    
    let zeroDiff = versionComponents.count - otherVersionComponents.count // <2>
    
    if zeroDiff == 0 { // <3>
                       // Same format, compare normally
      return self.compare(otherVersion, options: .numeric)
    } else {
      let zeros = Array(repeating: "0", count: abs(zeroDiff)) // <4>
      if zeroDiff > 0 {
        otherVersionComponents.append(contentsOf: zeros) // <5>
      } else {
        versionComponents.append(contentsOf: zeros)
      }
      return versionComponents.joined(separator: versionDelimiter)
        .compare(otherVersionComponents.joined(separator: versionDelimiter), options: .numeric) // <6>
    }
  }
}

// MARK: -
// MARK: Check if a string is a valid URL
public extension String {
  var validURL: Bool {
    let pattern = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
    return self.range(of: pattern, options: .regularExpression) != nil
  }
  
  var validEmail: Bool {
    let pattern = #"^\S+@\S+\.\S+$"#
    return self.range(of: pattern, options: .regularExpression) != nil
  }
  
  var validPhoneNumber: Bool {
    let pattern = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
    return self.range(of: pattern, options: .regularExpression) != nil
  }
}

public extension String {
  /*
   ```
   "https://sindresorhus.com".openUrl()
   ```
   */
  func openUrl() {
    URL(string: self)?.open()
  }
}

//https://www.avanderlee.com/swiftui/redacted-view-modifier/?utm_source=swiftlee&utm_medium=swiftlee_weekly&utm_campaign=issue_102
public extension String {
  static func placeholder(length: Int) -> String {
    String(Array(repeating: "X", count: length))
  }
}

public extension String {
  
  var md5: String {
    guard let data = self.data(using: .utf8) else { return "" }
    return data.shaString
  }
  
  func encodeUrl() -> String? {
    return self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
  }
  
  func decodeUrl() -> String? {
    return self.removingPercentEncoding
  }
  
  func capitalizingFirstLetter() -> String {
    prefix(1).capitalized + dropFirst()
  }
  
  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}

public extension String {
  func formatPhoneNumber(mask: String = "(XXX) XXX-XXXX") -> String {
    self.formatWith(mask: mask)
  }
  
  func formatDate(mask: String = "XX/XX/XXXX") -> String {
    self.formatWith(mask: mask)
  }
  
  func formatWith(mask: String) -> String {
    let cleanNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    
    var result     = ""
    var startIndex = cleanNumber.startIndex
    let endIndex   = cleanNumber.endIndex
    
    for char in mask where startIndex < endIndex {
      if char == "X" {
        result.append(cleanNumber[startIndex])
        startIndex = cleanNumber.index(after: startIndex)
      } else {
        result.append(char)
      }
    }
    
    return result
  }
}
