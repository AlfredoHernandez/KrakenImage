//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

@testable import KrakenImage
import XCTest

final class KrakenImageViewTests: XCTestCase {
    func test_init_doesNotRequestLoadImageFromRemote() {
        let (_, loader) = makeSUT()

        XCTAssertEqual(loader.loadedURLs, [])
    }

    func test_load_doesNotRequestLoadImageFromRemoteOnInvalidURL() {
        let (sut, loader) = makeSUT(url: invalidURL())

        sut.load()

        XCTAssertEqual(loader.loadedURLs, [])
    }

    func test_load_requestsLoadImageFromRemote() {
        let (sut, loader) = makeSUT()

        sut.load()

        XCTAssertEqual(loader.loadedURLs, [anyURL()])
    }

    // MARK: - Helpers

    private func makeSUT(url: URL? = anyURL(), file: StaticString = #file, line: UInt = #line) -> (KrakenImageView, KrakenImageDataLoaderSpy) {
        let loader = KrakenImageDataLoaderSpy()
        let sut = KrakenImageView(loader: loader, url: url)

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)

        return (sut, loader)
    }
}

class KrakenImageDataLoaderSpy: KrakenImageDataLoader {
    private var messages = [(url: URL, completion: (KrakenImageDataLoader.Result) -> Void)]()

    private(set) var cancelledURLs = [URL]()

    var loadedURLs: [URL] {
        return messages.map { $0.url }
    }

    private struct Task: KrakenImageDataLoaderTask {
        let callback: () -> Void
        func cancel() { callback() }
    }

    func loadImageData(from url: URL, completion: @escaping (KrakenImageDataLoader.Result) -> Void) -> KrakenImageDataLoaderTask {
        messages.append((url, completion))
        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
    }

    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }

    func complete(with data: Data, at index: Int = 0) {
        messages[index].completion(.success(data))
    }
}
