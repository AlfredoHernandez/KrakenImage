//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import UIKit

class KrakenImageViewController {
    private let loader: KrakenImageDataLoader
    private(set) var url: URL?
    private var task: KrakenImageDataLoaderTask?
    private(set) var imageView = KrakenImageView(image: nil)

    var setUrl: URL? {
        willSet {
            url = newValue
        }
    }

    var setImageAnimated = true {
        willSet {
            imageView.imageAnimated = newValue
        }
    }

    /// Indicates if the image loading task is loading
    public private(set) var isLoading: Bool = false {
        willSet {
            with(imageView.loadingControl) { [newValue] in
                newValue ? $0.startAnimating() : $0.stopAnimating()
            }
        }
    }

    init(loader: any KrakenImageDataLoader, url: URL?) {
        self.loader = loader
        self.url = url
    }

    /// Start loading image task
    public func load() {
        guard let url = url else { return }
        isLoading = true
        imageView.showRetryIndicator = false
        task = loader.loadImageData(from: url) { [weak self] result in
            switch result {
            case let .success(imageData):
                self?.imageView.setImage(from: imageData)
            case .failure:
                self?.imageView.showRetryIndicator = true
            }
            self?.isLoading = false
        }
    }

    /// Cancels the current loading image task
    public func cancel() {
        task?.cancel()
    }
}
