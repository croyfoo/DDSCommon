//
//  FIleManager+Extensions.swift
//  Tes
//
//  Created by David Croy on 6/2/22.
//  Copyright © 2022 DoubleDog Software. All rights reserved.
//

import Foundation
import ZIPFoundation
import CommonCrypto

public extension FileManager {
    
    func decryptFile(atPath filePath: String, withKey key: String) throws {
        let fileURL = URL(fileURLWithPath: filePath)
        let fileData = try Data(contentsOf: fileURL)
        
        guard let decryptedData = decrypt(data: fileData, key: key) else {
            throw NSError(domain: "DecryptionError", code: -1, userInfo: nil)
        }
        
        let decryptedFile = filePath.replacingOccurrences(of: ".psk", with: "")
        try decryptedData.write(to: URL(filePath: decryptedFile), options: .atomic)
        print("File decrypted successfully.")
    }
    
    func encryptFile(atPath filePath: String, withKey key: String) throws {
        let fileURL  = URL(fileURLWithPath: filePath)
        let fileData = try Data(contentsOf: fileURL)
        
        guard let encryptedData = encrypt(data: fileData, key: key) else {
            throw NSError(domain: "EncryptionError", code: -1, userInfo: nil)
        }
        
        let encryptedFile = "\(filePath).psk"
        try encryptedData.write(to: URL(filePath: encryptedFile), options: .atomic)
    }
    
    private func decrypt(data: Data, key: String) -> Data? {
        let keyData = key.data(using: .utf8)!
        let inputData = data as NSData
        let decryptedData = NSMutableData(length: Int(inputData.length) + kCCBlockSizeAES128)!
        let keyLength = size_t(kCCKeySizeAES128)
        let operation = CCOperation(kCCDecrypt)
        let algorithm = CCAlgorithm(kCCAlgorithmAES)
        let options = CCOptions(kCCOptionPKCS7Padding)
        
        var numBytesDecrypted: size_t = 0
        
        let cryptStatus = CCCrypt(
            operation,
            algorithm,
            options,
            (keyData as NSData).bytes, keyLength,
            nil,
            inputData.bytes, inputData.length,
            decryptedData.mutableBytes, decryptedData.length,
            &numBytesDecrypted
        )
        
        if cryptStatus == kCCSuccess {
            decryptedData.length = Int(numBytesDecrypted)
            return decryptedData as Data
        }
        
        return nil
    }
    private func encrypt(data: Data, key: String) -> Data? {
        let keyData = key.data(using: .utf8)!
        let inputData = data as NSData
        let encryptedData = NSMutableData(length: Int(inputData.length) + kCCBlockSizeAES128)!
        let keyLength = size_t(kCCKeySizeAES128)
        let operation = CCOperation(kCCEncrypt)
        let algorithm = CCAlgorithm(kCCAlgorithmAES)
        let options = CCOptions(kCCOptionPKCS7Padding)
        
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = CCCrypt(
            operation,
            algorithm,
            options,
            (keyData as NSData).bytes, keyLength,
            nil,
            inputData.bytes, inputData.length,
            encryptedData.mutableBytes, encryptedData.length,
            &numBytesEncrypted
        )
        
        if cryptStatus == kCCSuccess {
            encryptedData.length = Int(numBytesEncrypted)
            return encryptedData as Data
        }
        
        return nil
    }

}

public extension FileManager {
    
    func assetsFolder() -> URL {
        applicationSupportFolder().appendingPathComponent("ckAssetFiles")
    }
    
    func assetsFolderContents() -> [URL] {
        do {
            return try contentsOfDirectory(at: assetsFolder(), includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants, .skipsPackageDescendants] )
        } catch {
        }
        return [URL]()
    }
    
    func removeAssetFolderContents() {
        let assetFiles = assetsFolderContents()
        assetFiles.forEach { url in
            try? removeItem(at: url)
        }
    }
    
    func applicationSupportFolder() -> URL {
        let processName          = AppUtils.appName
        let applicationDirectory = try? url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true )
        let appSupportFolder     = applicationDirectory!.appendingPathComponent(processName)
        
        return appSupportFolder
    }
    
#if os(macOS)
    func scriptPaths() -> [String] {
        let scriptDirectoryURLs = scriptDirectoryURLs()
        var scriptPaths = [String]()
        for dir in scriptDirectoryURLs {
            var isDirectory: ObjCBool = false
            if let contents = try? contentsOfDirectory(atPath: dir.path) {
                for path in contents {
                    if fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue {
                        scriptPaths.append(path)
                    }
                }
            }
        }
        
        return scriptPaths
    }
    
    func scriptDirectoryURLs() -> [URL] {
        var scriptDirectoryURLS = [URL]()
        if responds(to: #selector(getter: ubiquityIdentityToken)) {
            scriptDirectoryURLS.append(contentsOf: urls(for: .applicationScriptsDirectory, in: .userDomainMask))
        }
        
        if scriptDirectoryURLS.isEmpty {
            let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
            let localScriptDir = ("~/Library/Application Scripts/" + bundleIdentifier as NSString).expandingTildeInPath
            scriptDirectoryURLS.append(URL(fileURLWithPath: localScriptDir))
        }
        
        return scriptDirectoryURLS
    }
    
    func scriptsFolderPath() -> String? {
        let scriptsURLs = scriptDirectoryURLs()
        if let scriptDirectory = scriptsURLs.first {
            createDirIfNotExist(at: scriptDirectory)
            return scriptDirectory.path
        }
        
        return nil
    }
#endif
    
    func extensionsFolderPath() -> String {
        return extensionRootFolder().path
    }
    
    func extensionRootFolder() -> URL {
        let applicationSupport = applicationSupportFolder()
        let pluginsFolder      = applicationSupport.appendingPathComponent("Extensions")
        
        createDirIfNotExist(at: pluginsFolder)
        
        return pluginsFolder
    }
    
    func extensionFolder(named name: String, create: Bool = true) -> URL {
        let extensionDirectory = extensionRootFolder().appendingPathComponent(name)
        //            .appendingPathExtension(ExtensionManager.pluginFilePathExtension)
        if create {
            createDirIfNotExist(at: extensionDirectory)
        }
        
        return extensionDirectory
    }
    
    func userLessFilePath() -> String {
        let userLessPath  = applicationSupportFolder().appendingPathComponent("user.less").path
        
        if !fileExists(atPath: userLessPath) {
            if let defaultUserless = Bundle.main.path(forResource: "default.user", ofType: "less") {
                try? self.copyItem(atPath: defaultUserless, toPath: userLessPath)
            }
        }
        
        return userLessPath
    }
 
    func directoryExists(at url: URL) -> Bool {
        return directoryExists(atPath: url.path)
    }
    
    func directoryExists(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        
        return fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
    
    private func createDirIfNotExist(at folder: URL) {
        
        guard !directoryExists(at: folder) else { return }
        
        try? createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
    }

}


extension Date {
    init(dateTime: (UInt16, UInt16)) {
        var msdosDateTime = Int(dateTime.0)
        msdosDateTime <<= 16
        msdosDateTime |= Int(dateTime.1)
        var unixTime = tm()
        unixTime.tm_sec = Int32((msdosDateTime&31)*2)
        unixTime.tm_min = Int32((msdosDateTime>>5)&63)
        unixTime.tm_hour = Int32((Int(dateTime.1)>>11)&31)
        unixTime.tm_mday = Int32((msdosDateTime>>16)&31)
        unixTime.tm_mon = Int32((msdosDateTime>>21)&15)
        unixTime.tm_mon -= 1 // UNIX time struct month entries are zero based.
        unixTime.tm_year = Int32(1980+(msdosDateTime>>25))
        unixTime.tm_year -= 1900 // UNIX time structs count in "years since 1900".
        let time = timegm(&unixTime)
        self = Date(timeIntervalSince1970: TimeInterval(time))
    }
    
    var fileModificationDateTime: (UInt16, UInt16) {
        return (self.fileModificationDate, self.fileModificationTime)
    }
    
    var fileModificationDate: UInt16 {
        var time = time_t(self.timeIntervalSince1970)
        guard let unixTime = gmtime(&time) else {
            return 0
        }
        var year = unixTime.pointee.tm_year + 1900 // UNIX time structs count in "years since 1900".
                                                   // ZIP uses the MSDOS date format which has a valid range of 1980 - 2099.
        year = year >= 1980 ? year : 1980
        year = year <= 2099 ? year : 2099
        let month = unixTime.pointee.tm_mon + 1 // UNIX time struct month entries are zero based.
        let day = unixTime.pointee.tm_mday
        return (UInt16)(day + ((month) * 32) +  ((year - 1980) * 512))
    }
    
    var fileModificationTime: UInt16 {
        var time = time_t(self.timeIntervalSince1970)
        guard let unixTime = gmtime(&time) else {
            return 0
        }
        let hour = unixTime.pointee.tm_hour
        let minute = unixTime.pointee.tm_min
        let second = unixTime.pointee.tm_sec
        return (UInt16)((second/2) + (minute * 32) + (hour * 2048))
    }
}

#if swift(>=4.2)
#else

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
#else

// The swift-corelibs-foundation version of NSError.swift was missing a convenience method to create
// error objects from error codes. (https://github.com/apple/swift-corelibs-foundation/pull/1420)
// We have to provide an implementation for non-Darwin platforms using Swift versions < 4.2.

public extension CocoaError {
    public static func error(_ code: CocoaError.Code, userInfo: [AnyHashable: Any]? = nil, url: URL? = nil) -> Error {
        var info: [String: Any] = userInfo as? [String: Any] ?? [:]
        if let url = url {
            info[NSURLErrorKey] = url
        }
        return NSError(domain: NSCocoaErrorDomain, code: code.rawValue, userInfo: info)
    }
}

#endif
#endif

public extension URL {
    func isContained(in parentDirectoryURL: URL) -> Bool {
        // Ensure this URL is contained in the passed in URL
        let parentDirectoryURL = URL(fileURLWithPath: parentDirectoryURL.path, isDirectory: true).standardized
        return self.standardized.absoluteString.hasPrefix(parentDirectoryURL.absoluteString)
    }
}

