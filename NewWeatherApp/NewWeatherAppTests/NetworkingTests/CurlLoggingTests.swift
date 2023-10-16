import Foundation
import XCTest

final class CurlLoggingTests: XCTestCase {

    let jsonString = """
        {"title": "Hello world"}
        """
    let urlString = "https://jsonplaceholder.typicode.com/posts"
    func testLogGet() {
        var urlRequest = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com")!)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("token", forHTTPHeaderField: "Authorization")
        let result = urlRequest.toCurlCommand()
        XCTAssertEqual(result, "curl \"https://jsonplaceholder.typicode.com\" \\\n\t-H 'Authorization: token'")
    }

    func testLogPost() {
        var urlRequest = URLRequest(url: URL(string:
                                                urlString)!)
        urlRequest.httpMethod = "POST"

        urlRequest.httpBody = jsonString.data(using: .utf8)
        let result = urlRequest.toCurlCommand()
        XCTAssertEqual(result, "curl \"https://jsonplaceholder.typicode.com/posts\" \\\n\t-X POST \\\n\t-d '{\"title\": \"Hello world\"}'")
    }

    func testLogPut() {
        var urlRequest = URLRequest(url: URL(string:
                                                urlString)!)
        urlRequest.httpMethod = "PUT"

        urlRequest.httpBody = jsonString.data(using: .utf8)
        let result = urlRequest.toCurlCommand()
        XCTAssertEqual(result, "curl \"https://jsonplaceholder.typicode.com/posts\" \\\n\t-X PUT \\\n\t-d '{\"title\": \"Hello world\"}'")
    }

    func testLogPatch() {
        var urlRequest = URLRequest(url: URL(string:
                                                urlString)!)
        urlRequest.httpMethod = "PATCH"

        urlRequest.httpBody = jsonString.data(using: .utf8)
        let result = urlRequest.toCurlCommand()
        XCTAssertEqual(result, "curl \"https://jsonplaceholder.typicode.com/posts\" \\\n\t-X PATCH \\\n\t-d '{\"title\": \"Hello world\"}'")
    }

    func testLogDelete() {
        var urlRequest = URLRequest(url: URL(string:
                                                "https://jsonplaceholder.typicode.com/posts/1")!)
        urlRequest.httpMethod = "DELETE"
        let result = urlRequest.toCurlCommand()
        XCTAssertEqual(result, "curl \"https://jsonplaceholder.typicode.com/posts/1\" \\\n\t-X DELETE")
    }
}
