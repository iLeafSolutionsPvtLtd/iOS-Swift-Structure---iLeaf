import Foundation
import Combine

public extension NetworkingClient {
    func get(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.get, route, params: params).publisher()
    }

    func post(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.post, route, params: params).publisher()
    }

    func put(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.put, route, params: params).publisher()
    }

    func patch(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.patch, route, params: params).publisher()
    }

    func delete(_ route: String, params: Params = Params()) -> AnyPublisher<Data, Error> {
        request(.delete, route, params: params).publisher()
    }
}

public extension NetworkingClient {
    func get(_ route: String, params: Params = Params()) async throws -> Data {
        try await request(.get, route, params: params).execute()
    }

    func post(_ route: String, params: Params = Params()) async throws -> Data {
        try await request(.post, route, params: params).execute()
    }

    func put(_ route: String, params: Params = Params()) async throws -> Data {
        try await request(.put, route, params: params).execute()
    }

    func patch(_ route: String, params: Params = Params()) async throws -> Data {
        try await request(.patch, route, params: params).execute()
    }

    func delete(_ route: String, params: Params = Params()) async throws -> Data {
        try await request(.delete, route, params: params).execute()
    }
}
