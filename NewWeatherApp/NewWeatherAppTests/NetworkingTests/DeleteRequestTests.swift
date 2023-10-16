import Foundation
import XCTest
import Combine

@testable
import NewWeatherApp

class DeleteRequestTests: XCTestCase {
    private let network = NetworkingClient(baseURL: "https://mocked.com")
    private var cancellables = Set<AnyCancellable>()
    private let finishedCalledText = "Finished called"
    private let receiveValueCalledText = "ReceiveValue called"
    private let fakeResponse = """
        {"response":"OK"}
        """
    private let usersPath = "/users"
    private let fakeURL = "https://mocked.com/users"
    private let methodName = "DELETE"
    override func setUpWithError() throws {
        network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }

    override func tearDownWithError() throws {
        MockingURLProtocol.mockedResponse = ""
        MockingURLProtocol.currentRequest = nil
    }

    func testDELETEVoidWorks() {
        MockingURLProtocol.mockedResponse = fakeResponse
        let expectationWorks = expectation(description: "Call works")
        let expectationFinished = expectation(description: "Finished")
        network.delete(usersPath).sink { completion in
            switch completion {
            case .failure:
                XCTFail()

            case .finished:
                    XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, self.methodName)
                    XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, self.fakeURL)
                expectationFinished.fulfill()
            }
        } receiveValue: { () in
            expectationWorks.fulfill()
        }
        .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }

    func testDELETEVoidAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
            fakeResponse
        let _: Void = try await network.delete(usersPath)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, methodName)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, fakeURL)
    }

    func testDELETEDataWorks() {
        MockingURLProtocol.mockedResponse =
            fakeResponse
        let expectationWorks = expectation(description: receiveValueCalledText)
        let expectationFinished = expectation(description: finishedCalledText)
        network.delete(usersPath).sink { completion in
            switch completion {
            case .failure:
                XCTFail()

            case .finished:
                    XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, self.methodName)
                    XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, self.fakeURL)
                expectationFinished.fulfill()
            }
        } receiveValue: { (data: Data) in
            XCTAssertEqual(data, MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
            expectationWorks.fulfill()
        }
        .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }

    func testDELETEDataAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
            fakeResponse
        let data: Data = try await network.delete(usersPath)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, methodName)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, fakeURL)
        XCTAssertEqual(data, MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
    }

    func testDELETEJSONWorks() {
        MockingURLProtocol.mockedResponse = fakeResponse
        let expectationWorks = expectation(description: receiveValueCalledText)
        let expectationFinished = expectation(description: finishedCalledText)
        network.delete(usersPath).sink { completion in
            switch completion {
            case .failure:
                XCTFail()

            case .finished:
                    XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, self.methodName)
                    XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, self.fakeURL)
                expectationFinished.fulfill()
            }
        } receiveValue: { (json: Any) in
            let data = try? JSONSerialization.data(withJSONObject: json, options: [])
            let expectedResponseData = """
        {"response":"OK"}
        """.data(using: String.Encoding.utf8)

            XCTAssertEqual(data, expectedResponseData)
            expectationWorks.fulfill()
        }
        .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }

    func testDELETEJSONAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
        fakeResponse
        let json: Any = try await network.delete(usersPath)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString,  fakeURL)
        let data = try? JSONSerialization.data(withJSONObject: json, options: [])
        let expectedResponseData =
        """
        {"response":"OK"}
        """.data(using: String.Encoding.utf8)
        XCTAssertEqual(data, expectedResponseData)
    }

    func testDELETENetworkingJSONDecodableWorks() {
        MockingURLProtocol.mockedResponse =
            """
        {
            "title":"Hello",
            "content":"World",
        }
        """
        let expectationWorks = expectation(description: receiveValueCalledText)
        let expectationFinished = expectation(description: finishedCalledText)
        network.delete("/posts/1")
            .sink { completion in
                switch completion {
                case .failure:
                    XCTFail()

                case .finished:
                        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, self.methodName)
                    XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/posts/1")
                    expectationFinished.fulfill()
                }
            } receiveValue: { (post: Post) in
                XCTAssertEqual(post.title, "Hello")
                XCTAssertEqual(post.content, "World")
                expectationWorks.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }

    func testDELETEDecodableWorks() {
        MockingURLProtocol.mockedResponse =
            """
        {
            "firstname":"John",
            "lastname":"Doe",
        }
        """
        let expectationWorks = expectation(description: receiveValueCalledText)
        let expectationFinished = expectation(description: finishedCalledText)
        network.delete("/users/1")
            .sink { completion in
                switch completion {
                case .failure:
                    XCTFail()

                case .finished:
                        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, self.methodName)
                    XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users/1")
                    expectationFinished.fulfill()
                }
            } receiveValue: { (userJSON: UserJSON) in
                XCTAssertEqual(userJSON.firstname, "John")
                XCTAssertEqual(userJSON.lastname, "Doe")
                expectationWorks.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }

    func testDELETEDecodableAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
            """
        {
            "firstname":"John",
            "lastname":"Doe",
        }
        """
        let userJSON: UserJSON = try await network.delete("/users/1")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, methodName)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users/1")
        XCTAssertEqual(userJSON.firstname, "John")
        XCTAssertEqual(userJSON.lastname, "Doe")
    }

    func testDELETEArrayOfDecodableWorks() {
        MockingURLProtocol.mockedResponse =
            """
        [
            {
                "firstname":"John",
                "lastname":"Doe"
            },
            {
                "firstname":"Jimmy",
                "lastname":"Punchline"
            }
        ]
        """
        let expectationWorks = expectation(description: receiveValueCalledText)
        let expectationFinished = expectation(description: finishedCalledText)
        network.delete(usersPath)
            .sink { completion in
                switch completion {
                case .failure:
                    XCTFail()

                case .finished:
                        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, self.methodName)
                        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, self.fakeURL)
                    expectationFinished.fulfill()
                }
            } receiveValue: { (userJSON: [UserJSON]) in
                XCTAssertEqual(userJSON[0].firstname, "John")
                XCTAssertEqual(userJSON[0].lastname, "Doe")
                XCTAssertEqual(userJSON[1].firstname, "Jimmy")
                XCTAssertEqual(userJSON[1].lastname, "Punchline")
                expectationWorks.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }

    func testDELETEArrayOfDecodableAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
            """
        [
            {
                "firstname":"John",
                "lastname":"Doe"
            },
            {
                "firstname":"Jimmy",
                "lastname":"Punchline"
            }
        ]
        """
        let users: [UserJSON] = try await network.delete(usersPath)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, methodName)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, fakeURL)
        XCTAssertEqual(users[0].firstname, "John")
        XCTAssertEqual(users[0].lastname, "Doe")
        XCTAssertEqual(users[1].firstname, "Jimmy")
        XCTAssertEqual(users[1].lastname, "Punchline")
    }

    func testDELETEArrayOfDecodableWithKeypathWorks() {
        MockingURLProtocol.mockedResponse =
            """
        {
        "users" :
            [
                {
                    "firstname":"John",
                    "lastname":"Doe"
                },
                {
                    "firstname":"Jimmy",
                    "lastname":"Punchline"
                }
            ]
        }
        """
        let expectationWorks = expectation(description: receiveValueCalledText)
        let expectationFinished = expectation(description: finishedCalledText)
        network.delete(usersPath, keypath: "users")
            .sink { completion in
                switch completion {
                case .failure:
                    XCTFail()

                case .finished:
                        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, self.methodName)
                        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, self.fakeURL)
                    expectationFinished.fulfill()
                }
            } receiveValue: { (userJSON: [UserJSON]) in
                XCTAssertEqual(userJSON[0].firstname, "John")
                XCTAssertEqual(userJSON[0].lastname, "Doe")
                XCTAssertEqual(userJSON[1].firstname, "Jimmy")
                XCTAssertEqual(userJSON[1].lastname, "Punchline")
                expectationWorks.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }
}
