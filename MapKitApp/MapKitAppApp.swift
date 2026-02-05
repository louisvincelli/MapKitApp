//
//  MapKitAppApp.swift
//  MapKitApp
//
//  Created by Louis Vincelli on 2/4/26.
//

import SwiftUI

@main
struct MapKitAppApp: App {
    
    @State private var vm = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            //anything in this view or child will have reference to that enviornment in which the obj vm will be in enviornment
            LocationsView()
                .environment(vm)
        }
    }
}
