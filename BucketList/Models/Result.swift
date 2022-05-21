//
//  Result.swift
//  BucketList
//
//  Created by Michael & Diana Pascucci on 5/20/22.
//

import SwiftUI

struct Result: Codable {
    
    // MARK: - PROPERTIES
    let query: Query
}

struct Query: Codable {
    
    // MARK: - PROPERTIES
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    
    // MARK: - PROPERTIES
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    // MARK: - COMPUTED PROPERTIES
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    
    // MARK: - METHODS
    static func <(lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
