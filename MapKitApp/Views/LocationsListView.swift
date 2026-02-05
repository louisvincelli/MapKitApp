//
//  LocationsListView.swift
//  MapKitApp
//
//  Created by Louis Vincelli on 2/4/26.
//

import SwiftUI

struct LocationsListView: View {
    
    @Environment(LocationsViewModel.self) var vm
    
    var body: some View {
        List {
            ForEach(vm.locations) { location in
                Button {
                    vm.showNextLocation(location: location)
                } label: {
                    listRowView(location: location)
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(PlainListStyle())
    }
}

#Preview {
    LocationsListView()
        .environment(LocationsViewModel())
}

extension LocationsListView {
    
    private func listRowView(location: Location) -> some View {
        HStack {
            // user first item of array
            //if let imageName = $0, do location in instead to loop in on each location and reference location.imageName.first
            if let imageName = location.imageNames.first {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading) {
                Text(location.name)
                    .font(.headline)
                Text(location.cityName)
                    .font(.subheadline)
            }
            // to cover whole list  row
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
