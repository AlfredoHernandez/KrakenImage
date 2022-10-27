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
    lazy var loadingControl: UIRefreshControl = UIRefreshControl()

    init(loader: KrakenImageDataLoader, url: URL?) {
        self.loader = loader
        self.url = url
    }

    func load() {
        guard let url = url else { return }
        isLoading = true
        loader.loadImageData(from: url) { [weak self] _ in
            self?.isLoading = false
        }
    }
}
