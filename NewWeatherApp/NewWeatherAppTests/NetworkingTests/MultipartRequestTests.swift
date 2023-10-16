import XCTest
import Combine

@testable import NewWeatherApp

final class MultipartRequestTests: XCTestCase {
    private let baseClient = NetworkingClient(baseURL: "https://example.com/")
    private let route = "/api/test"
    private let multyPartFormDataType = "multipart/form-data; boundary="
    private let contentType = "Content-Type"
    private let fileName = "file.txt"
    private let testName = "test_name"
    private let testData = "test data"
    private let mimeType = "text/plain"
    private let urlErrorMessage = "Properly-formed URL request was not constructed"

    func testRequestGenerationWithSingleFile() {
        // Set up test
        let params: Params = [:]
        let multipartData = MultipartData(name: testName,
                                          fileData: testData.data(using: .utf8)!,
                                          fileName: fileName,
                                          mimeType: mimeType)

        // Construct request
        let request = baseClient.request(.post, route, params: params)
        request.multipartData = [multipartData]

        if let urlRequest = request.buildURLRequest(),
           let body = urlRequest.httpBody,
           let contentTypeHeader = urlRequest.value(forHTTPHeaderField: contentType) {
            // Extract boundary from header
            XCTAssert(contentTypeHeader.starts(with: multyPartFormDataType))
            let boundary = contentTypeHeader.replacingOccurrences(of: multyPartFormDataType, with: "")

            // Test correct body construction
            let expectedBody = "--\(boundary)\r\nContent-Disposition: form-data; name=\"test_name\"; " +
                "filename=\"file.txt\"\r\nContent-Type: text/plain\r\n\r\ntest data\r\n--\(boundary)--"
            let actualBody = String(data: body, encoding: .utf8)
            XCTAssertEqual(actualBody, expectedBody)
        } else {
            XCTFail(urlErrorMessage)
        }
    }

    func testRequestGenerationWithParams() {
        // Set up test
        let params: Params = [testName: "test_value"]
        let multipartData = MultipartData(name: testName,
                                          fileData: testData.data(using: .utf8)!,
                                          fileName: fileName,
                                          mimeType: mimeType)

        // Construct request
        let request = baseClient.request(.post, route, params: params)
        request.multipartData = [multipartData]

        if let urlRequest = request.buildURLRequest(),
           let body = urlRequest.httpBody,
           let contentTypeHeader = urlRequest.value(forHTTPHeaderField: contentType) {
            // Extract boundary from header
            XCTAssert(contentTypeHeader.starts(with: multyPartFormDataType))
            let boundary = contentTypeHeader.replacingOccurrences(of: multyPartFormDataType, with: "")

            // Test correct body construction
            let expectedBody = "--\(boundary)\r\nContent-Disposition: " +
                "form-data; name=\"test_name\"\r\n\r\ntest_value\r\n--\(boundary)\r\nContent-Disposition: form-data; " +
                "name=\"test_name\"; filename=\"file.txt\"\r\nContent-Type: text/plain\r\n\r\ntest data\r\n--\(boundary)--"
            let actualBody = String(data: body, encoding: .utf8)
            XCTAssertEqual(actualBody, expectedBody)
        } else {
            XCTFail(urlErrorMessage)
        }
    }

    func testRequestGenerationWithMultipleFiles() {
        // Set up test
        let params: Params = [:]
        let multipartData = [
            MultipartData(name: testName,
                          fileData: testData.data(using: .utf8)!,
                          fileName: fileName,
                          mimeType: mimeType),
            MultipartData(name: "second_name",
                          fileData: "another file".data(using: .utf8)!,
                          fileName: "file2.txt",
                          mimeType: mimeType)
        ]

        // Construct request
        let request = baseClient.request(.post, route, params: params)
        request.multipartData = multipartData

        if let urlRequest = request.buildURLRequest(),
           let body = urlRequest.httpBody,
           let contentTypeHeader = urlRequest.value(forHTTPHeaderField: contentType) {
            // Extract boundary from header
            XCTAssert(contentTypeHeader.starts(with: multyPartFormDataType))
            let boundary = contentTypeHeader.replacingOccurrences(of: multyPartFormDataType, with: "")

            // Test correct body construction
            let expectedBody = "--\(boundary)\r\nContent-Disposition: form-data; name=\"test_name\"; " +
                "filename=\"file.txt\"\r\nContent-Type: text/plain\r\n\r\ntest " +
                "data\r\n--\(boundary)\r\nContent-Disposition: form-data; name=\"second_name\"; " +
                "filename=\"file2.txt\"\r\nContent-Type: text/plain\r\n\r\nanother file\r\n--\(boundary)--"
            let actualBody = String(data: body, encoding: .utf8)
            XCTAssertEqual(actualBody, expectedBody)
        } else {
            XCTFail(urlErrorMessage)
        }
    }
}
