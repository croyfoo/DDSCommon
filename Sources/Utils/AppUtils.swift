//
//  File.swift
//  
//
//  Created by David Croy on 1/22/22.
//

import Foundation

struct AppUtils {
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
    
    //    static func betaExpireDateFormatted() -> String {
    //        dateFormatter().string(from: betaExpireDate())
    //    }
    
    //    static func hasBetaExpired() -> Bool {
    //        betaExpired
    //        guard isBeta else { return false }
    //        return Date() > betaExpireDate()
    //    }
    
    //    static func betaExpireDate() -> Date {
    //        var future = DateComponents()
    //        future.day = 30
    //        return Calendar.current.date(byAdding: future, to: compileDate())!
    //    }
    
    static let appBundle        = Bundle.main.bundleIdentifier!
    static let containerKey     = "app"
    static let name             = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
    static let version          = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    static let build            = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    static let versionWithBuild = "\(version) (\(build))"
    static let copyright        = Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as! String
    static let isBeta           = false
    
    static func buildAsInt() -> Int {
        guard let buildInt = Int(build) else { return 0 }
        return buildInt
    }
    
    static func formatDate(_ date: Date) -> String {
        DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
    }
    
    static let osVersion: String = {
        let os = ProcessInfo.processInfo.operatingSystemVersion
        return "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
    }()
    
    static let hardwareModel: String = {
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var model = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.model", &model, &size, nil, 0)
        return String(cString: model)
    }()
    
    static let hostName: String = {
#if os(macOS)
        Host.current().localizedName ?? ""
#else
        ProcessInfo.processInfo.hostName
#endif
    }()
  
}