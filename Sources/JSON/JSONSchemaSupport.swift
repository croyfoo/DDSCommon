import Foundation

// MARK: - Helper functions for creating encoders and decoders

public func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}

public func newJSONEncoder(_ prettyPrint: Bool = true) -> JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601

    if prettyPrint {
        encoder.outputFormatting = .prettyPrinted
    }
    return encoder
}

// MARK: - URLSession response handlers

public extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }

//    func shelvesJSONTask(with url: URL, completionHandler: @escaping (ShelfsJSON?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//        self.codableTask(with: url, completionHandler: completionHandler)
//    }
}
