//
//  Copyright © 2022 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import Foundation

func with<A, B>(_ a: A, _ f: @escaping (A) -> B) -> B {
    f(a)
}
