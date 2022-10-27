//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

@testable import KrakenImage
import XCTest

final class KrakenImageViewControllerTests: XCTestCase {
    func test_init_doesNotPerformAnyURLRequest() {
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

    func test_load_displaysDefaultLoaderWhileDownloadingImage() {
        let (sut, loader) = makeSUT()
        XCTAssertFalse(sut.loadingControl.isRefreshing)

        sut.load()
        XCTAssertTrue(sut.loadingControl.isRefreshing, "Expected to display loader while loading image")
        XCTAssertTrue(sut.isLoading, "Expected to display loader while loading image")

        loader.complete(with: anyNSError())
        XCTAssertFalse(sut.loadingControl.isRefreshing, "Expected to not display loader after finish loading")
        XCTAssertFalse(sut.isLoading, "Expected to display loader while loading image")

        sut.load()
        XCTAssertTrue(sut.loadingControl.isRefreshing, "Expected to display loader while loading image")
        XCTAssertTrue(sut.isLoading, "Expected to display loader while loading image")

        loader.complete(with: anyData())
        XCTAssertFalse(sut.loadingControl.isRefreshing, "Expected to not display loader after finish loading")
        XCTAssertFalse(sut.isLoading, "Expected to display loader while loading image")
    }

    func test_load_displaysRetryIndicatorOnInvalidImageData() {
        let (sut, loader) = makeSUT()

        sut.load()
        XCTAssertEqual(sut.retryIndicator?.isHidden, true)

        loader.complete(with: anyNSError())
        XCTAssertEqual(sut.retryIndicator?.isHidden, false)

        sut.load()
        XCTAssertEqual(sut.retryIndicator?.isHidden, true)
    }

    func test_load_doesNotDisplayRetryIndicatorOnValidImageData() {
        let (sut, loader) = makeSUT()

        sut.load()
        XCTAssertEqual(sut.retryIndicator?.isHidden, true)

        loader.complete(with: anyData())
        XCTAssertEqual(sut.retryIndicator?.isHidden, true)

        sut.load()
        XCTAssertEqual(sut.retryIndicator?.isHidden, true)
    }

    func test_load_setsUIImageOnValidImageData() {
        let (sut, loader) = makeSUT()
        let expectedImageData = UIImage.make(withColor: .red).pngData()!

        sut.load()

        loader.complete(with: expectedImageData)
        XCTAssertEqual(sut.imageView.image?.pngData(), expectedImageData)
    }

    func test_load_doesNotSetUIImageOnInvalidImageData() {
        let (sut, loader) = makeSUT()
        let expectedImageData = anyData()

        sut.load()

        loader.complete(with: expectedImageData)
        XCTAssertNil(sut.imageView.image?.pngData())
    }

    func test_cancel_cancelsRequestedLoadingImage() {
        let (sut, loader) = makeSUT()
        sut.load()

        sut.cancel()

        XCTAssertEqual(loader.cancelledURLs, [anyURL()])
    }

    // MARK: - Helpers

    private func makeSUT(url: URL? = anyURL(), file: StaticString = #file, line: UInt = #line) -> (KrakenImageViewController, KrakenImageDataLoaderSpy) {
        let loader = KrakenImageDataLoaderSpy()
        let sut = KrakenImageViewController(loader: loader, url: url)

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)

        return (sut, loader)
    }
}
