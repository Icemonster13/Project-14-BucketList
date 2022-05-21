//
//  EditView.swift
//  BucketList
//
//  Created by Michael & Diana Pascucci on 5/20/22.
//

import SwiftUI

struct EditView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm: EditViewModel
    var onSave: (Location) -> Void

    // MARK: - BODY
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $vm.name)
                    TextField("Description", text: $vm.description)
                }
                
                Section("Nearby...") {
                    switch vm.loadingState {
                    case .loaded:
                        ForEach(vm.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text("; ") +
                            Text(page.description)
                                .italic()
                        }
                    case .loading:
                        Text("Loading...")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    let newLocation = vm.createNewLocation()
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await vm.fetchNearbyPlaces()
            }
        }
    }
    
    // MARK: - INITIALIZER
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _vm = StateObject(wrappedValue: EditViewModel(location: location))
    }
}

// MARK: - PREVIEW
struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { newLocation in }
    }
}
