//
//  File.swift
//
//
//  Created by David Croy on 8/21/22.
//

import Foundation

public struct AppUtils {
    
    private static var _dateFormatter: DateFormatter?
    
    static func dateFormatter() -> DateFormatter {
        guard _dateFormatter == nil else { return _dateFormatter! }
        let formatter                        = DateFormatter()
        formatter.timeStyle                  = .short
        formatter.dateStyle                  = .medium
        formatter.doesRelativeDateFormatting = true
        _dateFormatter                       = formatter
        
        return _dateFormatter!
    }
    
    
    public static let appBundle         = Bundle.main.bundleIdentifier!
    public static let appName           = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
    public static let appNameLowercased = appName.lowercased()
    public static let version           = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    public static let build             = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    public static let versionWithBuild  = "\(version) (\(build))"
    public static let copyright         = Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as! String
    //    public static let isBeta           = false
    
    public static func buildAsInt() -> Int {
        guard let buildInt = Int(build) else { return 0 }
        return buildInt
    }
    
    public static func formatDate(_ date: Date) -> String {
        DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
    }
    
    public static let osVersion: String = {
        let os = ProcessInfo.processInfo.operatingSystemVersion
        return "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
    }()
    
    public static let hardwareModel: String = {
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var model = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.model", &model, &size, nil, 0)
        return String(cString: model)
    }()
    
    public static let hostName: String = {
#if os(macOS)
        Host.current().localizedName ?? ""
#else
        ProcessInfo.processInfo.hostName
#endif
    }()
    
    public static var buildDate: Date {
        if let executableURL = Bundle.main.executableURL,
           let creation = (try? executableURL.resourceValues(forKeys: [.creationDateKey]))?.creationDate {
            return creation
        }
        return Date()
    }
}
