//
//  File.swift
//  
//
//  Created by David Croy on 8/21/22.
//

import Foundation
import SwiftUI

public enum Type: String {
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
case jpg
case gif
case tiff
case heic
case mp4
case mov
case guicktime
case dmg
case xip
case json
case tgz
case tar
case gzip
case bz2
case bzip2
case zip
case epub
case p12
case cer
case sql
case xcodeproj
case gz
case app
case md
    
    var desc: String {
        self.rawValue.uppercased()
    }
    
    var longDesc: LocalizedStringKey {
        switch self {
            case .png:
                return "PNG Image"
            case .jpg, .jpeg:
                return "JPEG Image"
            case .tiff:
                return "TIFF Image"
            case .heic:
                return "HEIC Image"
            case .img:
                return "Image"
            case .mov:
                return "MOV Movie"
            case .guicktime:
                return "Quicktime Movie"
            case .mp4:
                return "MP4 Movie"
            case .rtf, .rtfd:
                return "RTF File"
            case .pdf:
                return "PDF File"
            case .dmg:
                return "DMG File"
            case .xip:
                return "XIP File"
            case .json:
                return "JSON File"
            case .txt:
                return "Text"
            case .epub:
                return "EPUB Document"
            case .tar:
                return "Tar Archive"
            case .zip:
                return "ZIP Archive"
            case .bz2, .bzip2:
                return "BZIP Archive"
            case .gzip, .gz:
                return "GNU Zip Archive"
            case .tgz:
                return "Tar gzip Archive"
            case .p12:
                return "P12"
            case .cer:
                return "Certificate"
            case .sql:
                return "SQL"
            case .xcodeproj:
                return "xCode Project"
            case .app:
                return "Application"
            case .md:
                return "Markdown"
            default:
                return "Plain Text"
        }
    }
    
    var longDesc1: LocalizedStringKey {
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
        } else if isCompressedArhive {
            return "Archive"
        } else if isJSON {
            return "JSON"
        } else if isEPUB {
            return "EPUB"
        } else {
            return "Plain Text"
        }
    }
    
    var isImage: Bool {
        switch self {
            case .png, .jpeg, .gif, .tiff, .heic, .jpg, .img:
                return true
            default:
                return false
        }
    }
    
    var isMovie: Bool {
        self == .mov || self == .guicktime || self == .mp4
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
    
    var isJSON: Bool {
        self == .json
    }
    
    var isEPUB: Bool {
        return self == .epub
    }
    
    var isCompressedArhive: Bool {
        self == .zip || self == .tgz || self == .tar || self == .gzip || self == .bz2
    }
    
    var isApp: Bool {
        self == .app
    }
}
