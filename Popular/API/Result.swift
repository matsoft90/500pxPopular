//
//  Result.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import Foundation

/// Represents a generic result
///
/// - success: success will be of a specific type
/// - error: indicates an error result
enum Result<T> {
    case success(T)
    case error(Error)
}
