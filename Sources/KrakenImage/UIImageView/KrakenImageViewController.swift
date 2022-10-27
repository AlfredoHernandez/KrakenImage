//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import UIKit

public class KrakenImageViewController {
    private let loader: KrakenImageDataLoader
    private let url: URL?
    private var task: KrakenImageDataLoaderTask?
    private(set) var imageView = KrakenImageView(image: nil)

    /// Indicates if the image loading task is loading
    private(set) var isLoading: Bool = false {
        willSet {
            with(imageView.loadingControl) { [newValue] in
                newValue ? $0.startAnimating() : $0.stopAnimating()
            }
        }
    }

    init(loader: KrakenImageDataLoader, url: URL?) {
        self.loader = loader
        self.url = url
    }

    /// Start loading image task
    func load() {
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
    func cancel() {
        task?.cancel()
    }
}
