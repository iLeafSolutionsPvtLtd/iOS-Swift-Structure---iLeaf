import Foundation
@testable
import NewWeatherApp

extension Post: NetworkingJSONDecodable {
    static func decode(_ json: Any) throws -> Post {
        if let dic = json as? [String: Any] {
            let title: String = dic["title"] as? String ?? ""
            let content: String = dic["content"] as? String ?? ""
            return Post(title: title, content: content)
        }
        return Post(title: "", content: "")
    }
}
