//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Michael & Diana Pascucci on 5/20/22.
//

import SwiftUI
import MapKit
import LocalAuthentication

extension ContentView {
    final class ContentViewModel: ObservableObject {
        
        // MARK: - PROPERTIES
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations: [Location]
        @Published var selectedPlace: Location?
        @Published var isUnlocked = false
        
        @Published var showingAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        // MARK: - INITIALIZER
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        // MARK: - METHODS
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticateError in
                    
                    Task { @MainActor in
                        if success {
                            Task { @MainActor in self.isUnlocked = true }
                        } else {
                            self.alertTitle = "Failed to authenticate"
                            self.alertMessage = "Your BuketList was not unlocked!"
                            self.showingAlert = true
                        }
                    }
                }
            } else {
                self.alertTitle = "Biometrics are not available"
                self.alertMessage = "You will have to authenticate another way!"
                self.showingAlert = true
            }
        }
    }
}
