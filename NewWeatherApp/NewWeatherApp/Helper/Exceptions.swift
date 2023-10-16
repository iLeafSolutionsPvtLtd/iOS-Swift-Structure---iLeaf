//
//  Exceptions.swift
//  NewWeatherApp
//
//  Created by Arun on 10/10/23.
//

import Foundation
struct RuntimeError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}
