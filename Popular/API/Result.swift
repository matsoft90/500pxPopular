//
//  Result.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}
