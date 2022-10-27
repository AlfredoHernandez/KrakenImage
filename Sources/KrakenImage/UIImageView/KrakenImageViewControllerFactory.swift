//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenNetwork
import Foundation

public class KrakenImageViewControllerFactory {
    public static func build(url: URL?, imageLoader: KrakenImageDataLoader? = nil) -> KrakenImageViewController {
        guard let imageLoader = imageLoader else {
            let client = URLSessionHTTPClient()
            return KrakenImageViewController(loader: DispatchOnMainQueueDecoartor(RemoteKrakenImageDataLoader(client: client)), url: url)
        }
        let dispatchOnMainQueueLoader: KrakenImageDataLoader = DispatchOnMainQueueDecoartor(imageLoader)
        return KrakenImageViewController(loader: dispatchOnMainQueueLoader, url: url)
    }
}
