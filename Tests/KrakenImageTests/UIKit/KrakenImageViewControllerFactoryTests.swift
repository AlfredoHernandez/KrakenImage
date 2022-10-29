//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

@testable import KrakenImage
import XCTest

final class KrakenImageViewControllerFactoryTests: XCTestCase {
    func test_url_configuresUrlToLoad() {
        let (sut, _) = makeSUT()

        _ = sut.url(anyURL())
        XCTAssertEqual(sut.controller?.url, anyURL())

        _ = sut.url(nil)
        XCTAssertNil(sut.controller?.url)
    }

    func test_withAnimation_configuresAnimationLoading() {
        let (sut, _) = makeSUT()

        _ = sut.withAnimation(false)

        XCTAssertEqual(sut.controller?.imageView.imageAnimated, false)
    }

    func test_setToImageView_addsKrakenImageToGivenUIView() {
        let (sut, _) = makeSUT()
        let anyView = UIView()

        _ = sut.set(to: anyView)

        XCTAssertEqual(anyView.subviews, [sut.controller?.imageView])
    }

    func test_load_startsLoadingImage() {
        let (sut, loader) = makeSUT(url: anyURL())

        sut.load()
        loader.complete(with: anyData())

        XCTAssertEqual(loader.loadedURLs, [anyURL()])
    }

    func test_load_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT(url: anyURL())
        sut.load()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.complete(with: UIImage.make(withColor: .red).pngData()!)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func test_cancel_cancelsLoadingImage() {
        let (sut, loader) = makeSUT(url: anyURL())

        sut.load()
        sut.cancel()

        XCTAssertEqual(loader.cancelledURLs, [anyURL()])
    }

    // MARK: - Helpers

    private func makeSUT(url: URL? = nil, file: StaticString = #file, line: UInt = #line) -> (KrakenImageBuilder, KrakenImageDataLoaderSpy) {
        let loader = KrakenImageDataLoaderSpy()
        let sut = KrakenImageBuilder(url: url, imageLoader: loader)

        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
}
