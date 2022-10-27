//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

final class DispatchOnMainQueueDecoartor<T> {
    private(set) var decoratee: T

    init(_ decoratee: T) {
        self.decoratee = decoratee
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }

        completion()
    }
}

extension DispatchOnMainQueueDecoartor: KrakenImageDataLoader where T == KrakenImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (KrakenImageDataLoader.Result) -> Void) -> KrakenImageDataLoaderTask {
        decoratee.loadImageData(from: url) { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
