import Combine
import Foundation

public class NetworkingClient {
    /**
     Instead of using the same keypath for every call eg: "collection",
     this enables to use a default keypath for parsing collections.
     This is overridden by the per-request keypath if present.

     */
    public var defaultCollectionParsingKeyPath: String?
    var baseURL: String
    public var headers = [String: String]()
    public var parameterEncoding = ParameterEncoding.urlEncoded
    public var timeout: TimeInterval?
    public var sessionConfiguration = URLSessionConfiguration.default
    public var requestRetrier: NetworkRequestRetrier?
    public var jsonDecoderFactory: (() -> JSONDecoder)?

    /**
     Prints network calls to the console.
     Values Available are .None, Calls and CallsAndResponses.
     Default is None
     */
    public var logLevel: NetworkingLogLevel {
        get { logger.logLevel }
        set { logger.logLevel = newValue }
    }

    private let logger = NetworkingLogger()

    public init(baseURL: String, timeout: TimeInterval? = nil) {
        self.baseURL = baseURL
        self.timeout = timeout
    }

    public func toModel<T: NetworkingJSONDecodable>(_ json: Any, keypath: String? = nil) throws -> T {
        let data = resourceData(from: json, keypath: keypath)
        return try T.decode(data)
    }

    public func toModel<T: Decodable>(_ json: Any, keypath: String? = nil) throws -> T {
        let jsonObject = resourceData(from: json, keypath: keypath)
        let decoder = jsonDecoderFactory?() ?? JSONDecoder()
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        return try decoder.decode(T.self, from: data)
    }

    public func toModels<T: NetworkingJSONDecodable>(_ json: Any, keypath: String? = nil) throws -> [T] {
        guard let array = resourceData(from: json, keypath: keypath) as? [Any] else {
            return [T]()
        }
        return try array.map {
            try T.decode($0)
        }.compactMap { $0 }
    }

    public func toModels<T: Decodable>(_ json: Any, keypath: String? = nil) throws -> [T] {
        guard let array = resourceData(from: json, keypath: keypath) as? [Any] else {
            return [T]()
        }
        return try array.map { jsonObject in
            let decoder = jsonDecoderFactory?() ?? JSONDecoder()
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            return try decoder.decode(T.self, from: data)
        }.compactMap { $0 }
    }

    private func resourceData(from json: Any, keypath: String?) -> Any {
        if let keypath, !keypath.isEmpty, let dic = json as? [String: Any], let val = dic[keypath] {
            return val is NSNull ? json : val
        }
        return json
    }
}
