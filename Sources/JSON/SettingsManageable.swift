//
//  SettingsManageable.swift
//  AppSettings
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Appcoda. All rights reserved.
//
// swiftlint:disable switch_case_alignment
import Foundation

public enum EncoderType: CaseIterable {
    case json
    case plist
    case plistBinary

    public var ext: String {
        switch self {
            case .json:                return ".json"
            case .plist, .plistBinary: return ".plist"
        }
    }
}

fileprivate func fullURL(url: URL, name: String, type: EncoderType = .json) -> URL {
    url.appendingPathComponent(name).appendingPathExtension(type.ext)
}

public protocol SettingsManageable {
    func encode(type: EncoderType) -> Data
    func settingsURL(url: URL, type: EncoderType) -> URL
    func update(url: URL, overwrite: Bool, type: EncoderType) -> Bool
    func delete(url: URL) -> Bool
    func toDictionary(url: URL) -> [String: Any?]?
    func fileName(type: EncoderType) -> String
    static func name(url: URL?, type: EncoderType) -> URL
    mutating func load(url: URL) -> Bool
}

public extension SettingsManageable where Self: Codable {
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(data: Data) throws {
        self = try newJSONDecoder().decode(Self.self, from: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func from(fromURL url: URL) throws -> Self {
//        try Self.self.init(fromURL: fullURL(url: url, name: Self.self.name(url: url, type: .json)))
        try Self.self.init(fromURL: Self.name(url: url, type: .json))
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }

    @discardableResult
    func settingsURL(url: URL, type: EncoderType = .json) -> URL {
        url.appendingPathComponent(fileName(type: type))
    }
    
    @discardableResult
    func update(url: URL, overwrite: Bool = true, type: EncoderType = .json) -> Bool {
        guard overwrite && FileManager.default.fileExists(atPath: url.path ) else { return true }
        do {
            let encoded = encode(type: type)
            let fileURL = settingsURL(url: url, type: type)
            try encoded.write(to: fileURL)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    mutating func load(url: URL) -> Bool {
        for type in EncoderType.allCases {
            let fileName = settingsURL(url: url, type: type)
            if FileManager.default.fileExists(atPath: fileName.path) {
                do {
                    let fileContents = try Data(contentsOf: fileName)
                    switch type {
                        case .plist, .plistBinary:
                            self = try PropertyListDecoder().decode(Self.self, from: fileContents)
                        case .json:
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .iso8601
                            self = try decoder.decode(Self.self, from: fileContents)
                    }
                    return true
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        return false
    }
    
    func delete(url: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: settingsURL(url: url))
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}

extension SettingsManageable where Self: Codable {
    
    @discardableResult
    func encodeToPlist(asBinary: Bool = false) -> Data {
        let encoder           = PropertyListEncoder()
        encoder.outputFormat  = (!asBinary) ? .xml : .binary
        guard let encodedData = try? encoder.encode(self) else { return Data() }
        return encodedData
    }
    
    func encodeToJSON() -> Data {
        let encoder                  = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting     = .prettyPrinted
        guard let encodedData = try? encoder.encode(self) else { return Data() }
        
        return encodedData
    }

    public func toDictionary(url: URL) -> [String: Any?]? {
        do {
            let fileURL = settingsURL(url: url)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let fileContents = try Data(contentsOf: fileURL)
                let dictionary   = try PropertyListSerialization.propertyList(from: fileContents, options: .mutableContainersAndLeaves, format: nil) as? [String: Any?]
                return dictionary
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    public func encode(type: EncoderType = .plist) -> Data {
        switch type {
        case .plist:
            return encodeToPlist()
        case .plistBinary:
            return encodeToPlist(asBinary: true)
        case .json:
            return encodeToJSON()
        }
    }
}
