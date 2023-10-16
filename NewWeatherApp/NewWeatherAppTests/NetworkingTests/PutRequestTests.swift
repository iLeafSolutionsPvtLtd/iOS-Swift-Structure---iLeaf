import Foundation
import XCTest
import Combine

@testable
import NewWeatherApp

class PutRequestTests: XCTestCase {
    private let network = NetworkingClient(baseURL: "https://mocked.com")
    private var cancellables = Set<AnyCancellable>()
    private let finishedCalledText = "Finished called"
    private let usersPath = "/users"
    private let fakeResponse = """
        { "response": "OK" }
        """
    private let receiveValueCalledText = "ReceiveValue called"
    private let fakeURL = "https://mocked.com/users"
    private let methodName = "PUT"
    override func setUpWithError() throws {
        network.sessionConfiguration.protocolClasses = [MockingURLProtocol.self]
    }

    override func tearDownWithError() throws {
        MockingURLProtocol.mockedResponse = ""
        MockingURLProtocol.currentRequest = nil
    }

    func testPUTVoidWorks() {
        MockingURLProtocol.mockedResponse =
            fakeResponse
        let expectationWorks = expectation(description: "Call works")
        let expectationFinished = expectation(description: "Finished")
        network.put(usersPath).sink { completion in
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

    func testPUTVoidAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
            fakeResponse
        let _: Void = try await network.put(usersPath)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, methodName)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, fakeURL)
    }

    func testPUTDataWorks() {
        MockingURLProtocol.mockedResponse =
            fakeResponse
        let expectationWorks = expectation(description: receiveValueCalledText)
        let expectationFinished = expectation(description: finishedCalledText)
        network.put(usersPath).sink { completion in
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

    func testPUTDataAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
            fakeResponse
        let data: Data = try await network.put(usersPath)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, methodName)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, fakeURL)
        XCTAssertEqual(data, MockingURLProtocol.mockedResponse.data(using: String.Encoding.utf8))
    }

    func testPUTJSONWorks() {
        MockingURLProtocol.mockedResponse = fakeResponse
        let expectationWorks = expectation(description: receiveValueCalledText)
        let expectationFinished = expectation(description: finishedCalledText)
        network.put(usersPath).sink { completion in
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
            let expectedResponseData =
                """
            {"response":"OK"}
            """.data(using: String.Encoding.utf8)

            XCTAssertEqual(data, expectedResponseData)
            expectationWorks.fulfill()
        }
        .store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }

    func testPUTJSONAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse = fakeResponse
        let json: Any = try await network.put(usersPath)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, methodName)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, fakeURL)
        let data = try? JSONSerialization.data(withJSONObject: json, options: [])
        let expectedResponseData = """
        {"response":"OK"}
        """.data(using: String.Encoding.utf8)
        XCTAssertEqual(data, expectedResponseData)
    }

    func testPUTNetworkingJSONDecodableWorks() {
        MockingURLProtocol.mockedResponse =
            """
        {
            "title":"Hello",
            "content":"World",
        }
        """
        let expectationWorks = expectation(description: receiveValueCalledText)
        let expectationFinished = expectation(description: finishedCalledText)
        network.put("/posts/1")
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

    func testPUTDecodableWorks() {
        MockingURLProtocol.mockedResponse =
            """
        {
            "firstname":"John",
            "lastname":"Doe",
        }
        """
        let expectationWorks = expectation(description: receiveValueCalledText)
        let expectationFinished = expectation(description: finishedCalledText)
        network.put("/users/1")
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

    func testPUTDecodableAsyncWorks() async throws {
        MockingURLProtocol.mockedResponse =
            """
        {
            "firstname":"John",
            "lastname":"Doe",
        }
        """
        let user: UserJSON = try await network.put("/users/1")
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, methodName)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, "https://mocked.com/users/1")
        XCTAssertEqual(user.firstname, "John")
        XCTAssertEqual(user.lastname, "Doe")
    }

    func testPUTArrayOfDecodableWorks() {
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
        network.put(usersPath)
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

    func testPUTArrayOfDecodableAsyncWorks() async throws {
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
        let users: [UserJSON] = try await network.put(usersPath)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.httpMethod, methodName)
        XCTAssertEqual(MockingURLProtocol.currentRequest?.url?.absoluteString, fakeURL)
        XCTAssertEqual(users[0].firstname, "John")
        XCTAssertEqual(users[0].lastname, "Doe")
        XCTAssertEqual(users[1].firstname, "Jimmy")
        XCTAssertEqual(users[1].lastname, "Punchline")
    }

    func testPUTArrayOfDecodableWithKeypathWorks() {
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
        network.put(usersPath, keypath: "users")
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
