//
//  Data+Extensions.swift
//  Tes
//
//  Created by David Croy on 6/14/20.
//  Copyright © 2020 DoubleDog Software. All rights reserved.
//

import Foundation
import CommonCrypto
import CryptoKit
import SwiftUI

enum Type: String {
    case rtf
    case rtfd
    case img
    case txt
    case fileurl
    case webarchive
    case pdf
    case contactPict
    case contactID
    case url
    case snapplr
    case filemaker
    case fileImg
    case remote
    case png
    case jpeg
    case gif
    case tiff
    case heic
    case mp4
    case mov
    case guicktime
    case dmg
    case xip
    
    var desc: String {
        self.rawValue.uppercased()
    }
    
    var longDesc: LocalizedStringKey {
        if isImage {
            return "Image"
        } else if isMovie {
            return "Movie"
        } else if isRTF {
            return "Rich Text"
        } else if isPDF {
            return "PDF"
        } else if isDMG {
            return "DMG"
        } else if isXIP {
            return "XIP"
        } else {
            return "Plain Text"
        }
    }
    
    var isImage: Bool {
        switch self {
            case .png, .jpeg, .gif, .tiff, .heic, .img:
                return true
            default:
                return false
        }
    }
    
    var isMovie: Bool {
        self == .mov || self == .guicktime
    }
    
    var isMedia: Bool {
        isImage || isMovie
    }
    
    var isText: Bool {
        self == .txt
    }
    
    var isRTF: Bool {
        self == .rtf || self == .rtfd
    }
    
    var isPDF: Bool {
        self == .pdf
    }
    
    var isDMG: Bool {
        self == .dmg
    }
    
    var isXIP: Bool {
        self == .xip
    }
}


public extension Data {
    
    var sha256: [UInt8] {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(self.count), &digest)
        }
        return digest
    }
    
    var shaString: String {
        let digest   = self.sha256
        let hexBytes = digest.map { chars in String(format: "%02hhx", chars) }
        
        return hexBytes.joined().uppercased()
    }
    
    var shaString1: String {
        let hash       = SHA256.hash(data: self)
        let stringHash = hash.map { chars in String(format: "%02hhx", chars) }.joined()
        
        return stringHash.uppercased()
    }
}

enum ImageFormat: String {
    case PNG, JPEG, GIF, TIFF
    
    func displayType() -> String {
        rawValue
    }
}

extension Data {
    
    var imageFormat: Type {
        
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
