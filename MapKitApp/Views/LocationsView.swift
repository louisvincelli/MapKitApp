//
//  LocationsView.swift
//  MapKitApp
//
//  Created by Louis Vincelli on 2/4/26.
//

import SwiftUI
import MapKit
import Observation

//@Observable class LocationsViewModel {
//    
//    @Published var locations: [Location]
//
//    init() {
//        let location = LocationsDataService.locations
//        self.locations = location
//    }
//    
//}

struct LocationsView: View {
    
    //@State private var vm = LocationsViewModel()
    //@Environment private var vm: LocationsViewModel
    @Environment(LocationsViewModel.self) var vm
    // span is how zoomed in or zoomed out you want map to be. 0.1 fairly zoomed in
    
    // Old version
//    @State private var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    // NEW VERSION. goes in ViewModel
//    @State private var cameraPosition: MapCameraPosition = .region(
//        MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922),
//            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        )
//    )
    
    var body: some View {
        
        @Bindable var vm = vm
        
        ZStack {
            // position: $cameraPosition
            Map(position: $vm.mapRegion) {
                // Modern annotations
                ForEach(vm.locations) { location in
                    
                    // SWIFTUI MARKER
                    //Marker(location.name, coordinate: location.coordinates)
                    
                    // CUSTOM ANNOTATION
                    Annotation(location.name, coordinate: location.coordinates) {
                        LocationMapAnnotationView()
                            .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                            .shadow(radius: 10)
                            .onTapGesture {
                                vm.showNextLocation(location: location)
                            }
                    }
                    // Or use Annotation for custom content:
                    // Annotation(location.name, coordinate: location.coordinates) {
                    //     VStack {
                    //         Image(systemName: "mappin.circle.fill").foregroundStyle(.red)
                    //         Text(location.name).font(.caption)
                    //     }
                    // }
                    
                    // gives you the names as markers
//                    Annotation(location.name, coordinate: location.coordinates) {
//                        VStack(spacing: 4) {
//                            Image(systemName: "mappin.circle.fill")
//                                .font(.title)
//                                .foregroundStyle(.red)
//                            Text(location.name)
//                                .font(.caption)
//                                .fontWeight(.semibold)
//                                .padding(4)
//                                .background(.thinMaterial)
//                                .cornerRadius(6)
//                        }
                }

                // Optional: overlays, routes, etc.
                // MapPolygon(...)
                // MapPolyline(...)
            }
            .ignoresSafeArea()
//            Map(coordinateRegion: $mapRegion)
//                .ignoresSafeArea()
            VStack(spacing: 0) {
                header
                    .padding()
                
                Spacer()
                
                locationsPreviewStack
            }
        }
        .sheet(item: $vm.sheetLocation, onDismiss: nil) { location in
            LocationDetailView(location: location)
        }
        
        //checking to see if data api works
//        List {
//            ForEach(vm.locations) {
//                Text($0.name)
//                //Text(location.name)
//            }
//        }
    }
}

#Preview {
    LocationsView()
        .environment(LocationsViewModel())
}

extension LocationsView {
    
    private var header: some View {
        VStack {
            Button {
                vm.toggleLocationsList()
            } label: {
                Text(vm.mapLocation.name + ", " + vm.mapLocation.cityName)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: vm.mapLocation)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
                        // makes arrow turn upside down ^^^
                    }
            }
            
            // add items and delete items inside this VStack so it look like it scrolls down -> List
            if vm.showLocationsList {
                LocationsListView()
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
    
    private var mapLayer: some View {
        Text("Map layer goes here and remove from body")
    }
    
    private var locationsPreviewStack: some View {
        ZStack {
            ForEach(vm.locations) { location in
                if vm.mapLocation == location {
                    LocationPreviewView(location: location)
                        .shadow(color: Color.black.opacity(0.3), radius: 20)
                        .padding()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            }
        }
    }
}
