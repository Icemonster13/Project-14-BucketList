//
//  ContentView.swift
//  BucketList
//
//  Created by Michael & Diana Pascucci on 5/20/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    // MARK: - PROPERTIES
    @StateObject private var vm = ContentViewModel()
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            if vm.isUnlocked {
                Map(coordinateRegion: $vm.mapRegion, annotationItems: vm.locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .fixedSize()
                        }
                        .onTapGesture {
                            vm.selectedPlace = location
                        }
                    }
                }
                .ignoresSafeArea()
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            vm.addLocation()
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                }
                .sheet(item: $vm.selectedPlace) { place in
                    EditView(location: place) { vm.update(location: $0) }
                }
            } else {
                Button("Unlock Places") {
                    vm.authenticate()
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .alert(isPresented: $vm.showingAlert) {
                    Alert(title: Text("\(vm.alertTitle)"), message: Text("\(vm.alertMessage)"))
                }
            }
        }
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
