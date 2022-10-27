//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation
import KrakenNetwork

internal final class RemoteKrakenImageDataLoader: KrakenImageDataLoader {
    private let client: HTTPClient

    internal init(client: HTTPClient) {
        self.client = client
    }

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    private final class HTTPClientTaskWrapper: KrakenImageDataLoaderTask {
        private var completion: ((KrakenImageDataLoader.Result) -> Void)?

        var wrapped: HTTPClientTask?

        init(_ completion: @escaping (KrakenImageDataLoader.Result) -> Void) {
            self.completion = completion
        }

        func complete(with result: KrakenImageDataLoader.Result) {
            completion?(result)
        }

        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }

        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    internal func loadImageData(from url: URL, completion: @escaping (KrakenImageDataLoader.Result) -> Void) -> KrakenImageDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            task.complete(with: result
                .mapError { _ in Error.connectivity }
                .flatMap { data, response in
                    let isValidResponse = response.isOK && !data.isEmpty
                    return isValidResponse ? .success(data) : .failure(Error.invalidData)
                })
        }
        return task
    }
}
