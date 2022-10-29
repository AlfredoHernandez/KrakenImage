//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenNetwork
import UIKit

public struct KrakenImageBuilder {
    private(set) var controller: KrakenImageViewController?

    private init(controller: KrakenImageViewController) {
        self.controller = controller
    }

    public init(url: URL? = nil, imageLoader: KrakenImageDataLoader? = nil) {
        guard let imageLoader = imageLoader else {
            let client = URLSessionHTTPClient()
            self = KrakenImageBuilder(
                controller: KrakenImageViewController(
                    loader: DispatchOnMainQueueDecoartor(
                        RemoteKrakenImageDataLoader(client: client)
                    ),
                    url: url
                )
            )
            return
        }
        let dispatchOnMainQueueLoader: KrakenImageDataLoader = DispatchOnMainQueueDecoartor(imageLoader)
        self = KrakenImageBuilder(controller: KrakenImageViewController(loader: dispatchOnMainQueueLoader, url: url))
    }

    public func url(_ url: URL?) -> KrakenImageBuilder {
        controller?.setUrl = url
        return self
    }

    public func withAnimation(_ animated: Bool = true) -> KrakenImageBuilder {
        controller?.setImageAnimated = animated
        return self
    }

    @discardableResult
    public func set(to view: UIView?) -> KrakenImageBuilder {
        guard let controller = controller, let view = view else { return self }
        view.addSubview(controller.imageView)
        controller.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controller.imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controller.imageView.topAnchor.constraint(equalTo: view.topAnchor),
            controller.imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        return self
    }

    public func load() {
        controller?.load()
    }

    public func cancel() {
        controller?.cancel()
    }
}
