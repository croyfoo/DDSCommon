//
//  FIleManager+Extensions.swift
//  Tes
//
//  Created by David Croy on 6/2/22.
//  Copyright © 2022 DoubleDog Software. All rights reserved.
//

import Foundation

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
