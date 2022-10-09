//
//  Data+Extensions.swift
//  Tes
//
//  Created by David Croy on 6/14/20.
//  Copyright © 2020 DoubleDog Software. All rights reserved.
//

import Foundation
import CryptoKit

public extension Data {
    
    var shaString: String {
        let hash       = SHA256.hash(data: self)
        let stringHash = hash.map { chars in String(format: "%02hhx", chars) }.joined()
        
        return stringHash.uppercased()
    }
}

public enum ImageFormat: String {
    case PNG, JPEG, GIF, TIFF
    
    func displayType() -> String {
        rawValue
    }
}

public extension Data {

    internal var imageFormat: Type {

        var values = [UInt8](repeating: 0, count: 1)
        self.copyBytes(to: &values, count: 1)
        
        let ext: Type
        switch values[0] {
        case 0xFF:
            ext = .jpeg
        case 0x89:
            ext = .png
        case 0x47:
            ext = .gif
        case 0x49, 0x4D :
            ext = .tiff
        default:
            ext = isPDF ? .pdf : isHeic ? .heic : .img
        }
        
        return ext
    }
    
    var isPDF: Bool {
        guard count >= 1024 else { return false }
        let pdfHeader = Data(bytes: "%PDF", count: 4)
        return self.range(of: pdfHeader, options: [], in: Range(NSRange(location: 0, length: 1024))) != nil
    }
    
    var isHeic: Bool {
        var values = [UInt8](repeating: 0, count: 12)
        self.copyBytes(to: &values, count: 12)
        let bytes  = values[4...11]
        let str    = String(bytes: bytes, encoding: .utf8)
        let isHeic = str == "ftypheic"
        return isHeic
    }

}

public extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }

    // git@github.com:davbeck/MultipartForm.git
    mutating func append(_ string: String) {
        self.append(string.data(using: .utf8, allowLossyConversion: true)!)
    }
}


