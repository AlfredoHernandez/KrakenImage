//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenImage
import XCTest

final class KrakenImageViewControllerFactoryTests: XCTestCase {
    func test_load_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.load()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.complete(with: UIImage.make(withColor: .red).pngData()!)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL? = anyURL(), file: StaticString = #file, line: UInt = #line) -> (KrakenImageViewController, KrakenImageDataLoaderSpy) {
        let loader = KrakenImageDataLoaderSpy()
        let sut = KrakenImageViewControllerFactory.build(url: url, imageLoader: loader)

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)

        return (sut, loader)
    }
}
