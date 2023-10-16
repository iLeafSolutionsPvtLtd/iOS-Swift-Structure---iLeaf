import Foundation

class MockingURLProtocol: URLProtocol {
    static var mockedResponse = ""
    static var currentRequest: URLRequest?

    override class func canInit(with request: URLRequest) -> Bool {
        currentRequest = request
        return request.url?.host == "mocked.com"
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let data = MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8)
        DispatchQueue.global(qos: .default).async {
            self.client?.urlProtocol(self, didLoad: data!)
            self.client?.urlProtocol(self, didReceive: URLResponse(), cacheStoragePolicy: URLCache.StoragePolicy.allowed)
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {
        // No implementation needed here
    }
}
