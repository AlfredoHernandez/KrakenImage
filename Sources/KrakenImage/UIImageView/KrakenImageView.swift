//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import UIKit

public class KrakenImageView {
    private let loader: KrakenImageDataLoader
    private let url: URL?
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

    init(loader: KrakenImageDataLoader, url: URL?) {
        self.loader = loader
        self.url = url
    }

    func load() {
        guard let url = url else { return }
        isLoading = true
        retryIndicator?.isHidden = true
        loader.loadImageData(from: url) { [weak self] result in
            switch result {
            case .success:
                break
            case .failure:
                self?.retryIndicator?.isHidden = false
            }

            self?.isLoading = false
        }
    }
}
