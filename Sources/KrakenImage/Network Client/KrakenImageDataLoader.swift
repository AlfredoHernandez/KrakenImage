//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

public protocol KrakenImageDataLoaderTask {
    func cancel()
}

public protocol KrakenImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> KrakenImageDataLoaderTask
}
