//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

@testable import KrakenImage
import SnapshotTesting
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
        XCTAssertFalse(sut.isLoading)

        sut.load()
        XCTAssertTrue(sut.isLoading, "Expected to display loader while loading image")

        loader.complete(with: anyNSError())
        XCTAssertFalse(sut.isLoading, "Expected to display loader while loading image")

        sut.load()
        XCTAssertTrue(sut.isLoading, "Expected to display loader while loading image")

        loader.complete(with: anyData())
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
    
    // UI Kit Component
    
    func test_state_withLoadedImage() {
        let (sut, loader) = makeSUT()
        let viewController = TestKrakenImageViewController()
        viewController.krakenImageViewController = sut
        
        viewController.krakenImageViewController.load()
        loader.complete(with: UIImage.make(withColor: .blue).pngData()!)

        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro))
    }
    
    func test_state_withLoadingControlWhileLoadingImage() {
        let (sut, _) = makeSUT()
        let viewController = TestKrakenImageViewController()
        viewController.krakenImageViewController = sut
        
        viewController.krakenImageViewController.load()
        
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro))
    }
    
    func test_state_displaysRetryComponent_onFailedLoadedImage() {
        let (sut, loader) = makeSUT()
        let viewController = TestKrakenImageViewController()
        viewController.krakenImageViewController = sut
        
        viewController.krakenImageViewController.load()
        loader.complete(with: anyNSError())
        
        assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro))
    }

    // MARK: - Helpers

    private func makeSUT(url: URL? = anyURL(), file: StaticString = #file, line: UInt = #line) -> (KrakenImageViewController, KrakenImageDataLoaderSpy) {
        let loader = KrakenImageDataLoaderSpy()
        let sut = KrakenImageViewController(loader: loader, url: url)

        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)

        return (sut, loader)
    }
    
    class TestKrakenImageViewController: UIViewController {
        lazy var krakenImageViewController = KrakenImageViewController(
            loader: KrakenImageDataLoaderSpy(),
            url: anyURL()
        )
        
        override func viewDidLoad() {
            super.viewDidLoad()
            krakenImageViewController.imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(krakenImageViewController.imageView)
            NSLayoutConstraint.activate([
                krakenImageViewController.imageView.widthAnchor.constraint(equalToConstant: 200),
                krakenImageViewController.imageView.heightAnchor.constraint(equalToConstant: 200),
                krakenImageViewController.imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                krakenImageViewController.imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
        }
    }
}

extension KrakenImageViewController {
    var retryIndicator: UIView? {
        self.imageView.retryIndicator
    }
}
