//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

internal protocol KrakenImageDataLoaderTask {
    func cancel()
}

internal protocol KrakenImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> KrakenImageDataLoaderTask
}
