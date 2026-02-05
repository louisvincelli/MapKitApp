//
//  Location.swift
//  MapKitApp
//
//  Created by Louis Vincelli on 2/4/26.
//

import Foundation
import MapKit

// if we have 2 diff locations in our code identify if equal or not. can make it hashable
struct Location: Identifiable, Equatable {
    //let id = UUID().uuidString
    // if we had location w same name then we create exact same 2 locations twice in code with different id's. We want them to have same identifiable.
    //let id: String
    let name: String
    let cityName: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageNames: [String]
    let link: String
    
    //Conformed to Identifiable. each location will have a specific id.
    var id: String {
        //name = "Colosseum"
        // cityName = "Rome"
        // id = "CollosseumRome"
        // same cities names can come in diff locations, or viceversa. To allow repeated names
        //name + cityName
        "\(name)-\(cityName)"
        // can put more here if you want tight id security, specific id or hashable.
    }
    
    //Equatable. if 2 locations have same id, theyre the same location
    static func == (lhs: Location, rhs: Location) -> Bool {
        // if two locations have same id then they are same location
        lhs.id == rhs.id
    }
}

//not an array of images but string, not including image asset in our location. Reference to the name only get image once it's actually on the screen
