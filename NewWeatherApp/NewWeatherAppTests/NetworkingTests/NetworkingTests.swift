import XCTest
import Combine
@testable
import NewWeatherApp

final class NetworkingTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var cancellable: Cancellable?

    func testBadURLDoesntCrash() {
        let exp = expectation(description: "call")
        let client = NetworkingClient(baseURL: "https://jsonplaceholder.typicode.com")
        client.get("/forge a bad url")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    debugPrint("finished")

                case .failure(let error):
                    if let error = error as? NetworkingError, error.status == .notFound {
                        exp.fulfill()
                    }
                }
            },
            receiveValue: { (json: Any) in
                debugPrint(json)
            }).store(in: &cancellables)
        waitForExpectations(timeout: 2, handler: nil)
    }
}
