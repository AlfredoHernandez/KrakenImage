//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func invalidURL() -> URL? {
    return URL(string: "invalid url")
}

func anyData() -> Data {
    return Data("any data".utf8)
}
