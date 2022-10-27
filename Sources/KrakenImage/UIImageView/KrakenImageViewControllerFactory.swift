//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import KrakenNetwork
import Foundation

public class KrakenImageViewControllerFactory {
    public static func build(url: URL?) -> KrakenImageViewController {
        let client = URLSessionHTTPClient()
        let imageLoader = RemoteKrakenImageDataLoader(client: client)
        return KrakenImageViewController(loader: imageLoader, url: url)
    }
}
