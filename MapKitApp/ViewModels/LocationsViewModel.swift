//
//  LocationsViewModel.swift
//  MapKitApp
//
//  Created by Louis Vincelli on 2/4/26.
//

import Foundation
import Observation
import SwiftUI
import MapKit

@Observable class LocationsViewModel {
    
    // All loaded location
    //@Published var locations: [Location]
    var locations: [Location]
    
    // Current location on the map
    var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    // never have to update mapRegion again. just change mapLocation and it'll automatically call function to update current region. if change mapLocation variable, map updates automatically.
    var mapRegion: MapCameraPosition
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    // Show list of locations
    var showLocationsList: Bool = false
    
    // Show location detail via sheet. start at nil so it doesnt come up first
    var sheetLocation: Location? = nil

    init() {
        // get all locations from data service
        let locations = LocationsDataService.locations
        self.locations = locations
        // first location from first data service array
        // explicit unwrap will never fail because hard coded data and we'll get at least 1 item inside the array.
        let first = locations.first!
        self.mapLocation = first
        
        self.mapRegion = .region(
            MKCoordinateRegion(
                center: first.coordinates,
                span: mapSpan
            )
        )
    }
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = .region(
                MKCoordinateRegion(
                    center: location.coordinates,
                    span: mapSpan)
                )
        }
    }
    
    public func toggleLocationsList() {
        withAnimation(.easeInOut)  {
            //showLocationsList = !showLocationsList
            showLocationsList.toggle()
        }
    }
    
    public func showNextLocation(location: Location) {
        // change mapLocation which changes mapRegion
        withAnimation(.easeInOut) {
            mapLocation = location
            // always close location list after clicking on a location and open map
            showLocationsList = false
        }
    }
    
    
    
    // find next location for button pressing
    public func nextButtonPressed() {
        
        // Get current index
//        let currentIndex = locations.firstIndex { location in
//            return location == mapLocation
//        }
        
        // More efficient:
        guard let currentIndex = locations.firstIndex(where: {$0 == mapLocation}) else {
            print("Could not find current index in locations array! Should never happen.")
            return
        }
        
        // Check if the currentIndex is valid
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            // Next index is NOT valid
            // Restart from 0
            // if last item in array go back to first item
            guard let firstLocation = locations.first else { return }
            showNextLocation(location: firstLocation)
            return
        }
        // Next index IS valid
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
    }
    
}
