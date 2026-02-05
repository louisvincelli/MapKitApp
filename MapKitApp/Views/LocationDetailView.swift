//
//  LocationDetailView.swift
//  MapKitApp
//
//  Created by Louis Vincelli on 2/5/26.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    
    @Environment(LocationsViewModel.self) var vm
    @Environment(\.horizontalSizeClass) private var hSizeClass
    // on iPad the horizontal size class is usually .regular
    
    let location: Location
    
    var body: some View {
        // GeometryReader { proxy in ... width: proxy.size.width}
        ScrollView {
            VStack {
                imageSection
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                VStack(alignment: .leading, spacing: 16) {
                    titleSection
                    Divider()
                    descriptionSection
                    Divider()
                    mapLayer2
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(backButton, alignment: .topLeading)
    }
}

#Preview {
    LocationDetailView(location: LocationsDataService.locations.first!)
        .environment(LocationsViewModel())
}

extension LocationDetailView {
    
    private var imageSection: some View {
        TabView {
            // imageNames is array of strings which conform to hashables
            ForEach(location.imageNames, id: \.self) { imageName in
                //Image($0)
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                // not scaled to fit
                    //.frame(height: 300)
                    //.frame(width: .infinity)
                    //.frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : .infinity)
                
                // IPAD VS IPHONE --------------------
                    .frame(width: hSizeClass == .regular ? nil : .infinity)
                    .clipped()
            }
        }
        .frame(height: 500)
        //.tabViewStyle(PageTabViewStyle())
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        //.background(.ultraThinMaterial)
        .safeAreaPadding(.bottom)
        //.ignoresSafeArea(edges: .top)
        
        //build own dots ...
//        ZStack(alignment: .bottom) {
//                TabView(selection: $index) {
//                    ForEach(0..<images.count, id: \.self) { i in
//                        Image(images[i])
//                            .resizable()
//                            .scaledToFill()
//                            .tag(i)
//                    }
//                }
//                .tabViewStyle(.page)
//
//                HStack(spacing: 8) {
//                    ForEach(0..<images.count, id: \.self) { i in
//                        Circle()
//                            .fill(i == index ? Color.white : Color.white.opacity(0.4))
//                            .frame(width: i == index ? 8 : 6, height: i == index ? 8 : 6)
//                    }
//                }
//                .padding(.bottom, 12)
//            }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(location.cityName)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(location.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if let url = URL(string: location.link) {
                Link("Read More", destination: url)
                    .font(.headline)
                //.tint(.blue) for links
            }
        }
    }
    
    // OLD VERSION
//    private var mapLayer: some View {
//        Map(coordinateRegion: .constant(MKCoordinateRegion(center: location.coordinates, span: vm.mapSpan)), annotationItems: [location]) { location in
//            MapAnnotation(coordinate: location.coordinates) {
//                LocationMapAnnotationView()
//                    .shadow(radius: 10)
//            }
//        }
//        .aspectRatio(1, contentMode: .fit)
//        .cornerRadius(30)
//    }
    
    
    // NEW VERSION:
    private var mapLayer2: some View {
        let camera = MapCameraPosition.region(
            MKCoordinateRegion(center: location.coordinates,
                               // to zoomed out, so created custom
                               //span: vm.mapSpan
                               span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                              )
        )
        return Map(position: .constant(camera)) {
            Annotation(location.name, coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .shadow(radius: 10)
            }
        }
        // doesnt let user use or drag map around
        .allowsHitTesting(false)
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(30)
    }
    
    private var backButton: some View {
        Button {
            vm.sheetLocation = nil
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundStyle(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
        }
    }
}

