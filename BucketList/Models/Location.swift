//
//  Location.swift
//  BucketList
//
//  Created by Michael & Diana Pascucci on 5/20/22.
//

import SwiftUI
import MapKit

struct Location: Identifiable, Codable, Equatable {
    
    // MARK: - PROPERTIES
    var id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
    
    // MARK: - COMPUTED PROPERTIES
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // MARK: - METHODS
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: - EXAMPLE
    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Where Queen Elizabeth lives with her dorgis", latitude: 51.501, longitude: -0.141)
}
