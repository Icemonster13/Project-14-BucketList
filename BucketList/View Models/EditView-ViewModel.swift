//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Michael & Diana Pascucci on 5/21/22.
//

import SwiftUI

extension EditView {
    final class EditViewModel: ObservableObject {
        
        // MARK: - ENUMERATIONS
        enum LoadingState {
            case loading, loaded, failed
        }
        
        // MARK: - PROPERTIES
        @Published var name: String
        @Published var description: String
        @Published var loadingState = LoadingState.loading
        @Published var pages = [Page]()
        
        var location: Location
        
        // MARK: - INITIALIZER
        init(location: Location) {
            name = location.name
            description = location.description
            self.location = location
        }
        
        // MARK: - METHODS
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                let items = try JSONDecoder().decode(Result.self, from: data)
                
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
        
        func createNewLocation() -> Location {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description
            return newLocation
        }
    }
}
