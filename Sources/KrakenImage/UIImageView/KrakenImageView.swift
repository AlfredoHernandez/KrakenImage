//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import UIKit

public class KrakenImageView {
    private let loader: KrakenImageDataLoader
    private let url: URL?

    init(loader: KrakenImageDataLoader, url: URL?) {
        self.loader = loader
        self.url = url
    }

    func load() {
        guard let url = url else { return }
        loader.loadImageData(from: url) { _ in
        }
    }
}
