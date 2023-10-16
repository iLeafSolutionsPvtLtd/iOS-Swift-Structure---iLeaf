//
//  PublicHashes.swift
//  Scramble
//
//  Created by Ansar on 05/07/23.
//

import Foundation

struct PublicHash: Codable {
    let pattern: String
    let hashes: [String]
}

struct PublicHashes: Codable {
    let publicHashes: [PublicHash]
    enum CodingKeys: String, CodingKey {
        case publicHashes = "public_hashes"
    }
}
