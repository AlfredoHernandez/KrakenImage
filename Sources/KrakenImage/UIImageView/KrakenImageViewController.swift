//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import UIKit

public class KrakenImageViewController {
    private let loader: KrakenImageDataLoader
    private let url: URL?
    private var task: KrakenImageDataLoaderTask?

    private(set) var isLoading: Bool = false {
        willSet {
            newValue ? loadingControl.beginRefreshing() : loadingControl.endRefreshing()
        }
    }

    /// Displayed component when image is loading
    lazy var loadingControl: UIRefreshControl = .init()

    /// Component to retry download image
    private(set) lazy var retryIndicator: UIView? = with(UIButton()) { button in
        button.isHidden = true
        return button
    }

    private(set) lazy var imageView: UIImageView = with(UIImageView()) { iv in
        iv
    }

    init(loader: KrakenImageDataLoader, url: URL?) {
        self.loader = loader
        self.url = url
    }

    /// Start loading image task
    func load() {
        guard let url = url else { return }
        isLoading = true
        retryIndicator?.isHidden = true
        task = loader.loadImageData(from: url) { [weak self] result in
            switch result {
            case let .success(imageData):
                self?.imageView.image = UIImage(data: imageData)
            case .failure:
                self?.retryIndicator?.isHidden = false
            }

            self?.isLoading = false
        }
    }

    /// Cancels the current loading image task
    func cancel() {
        task?.cancel()
    }
}
