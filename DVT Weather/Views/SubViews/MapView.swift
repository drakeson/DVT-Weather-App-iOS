//
//  MapView.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 07/08/2023.
//

import SwiftUI
import MapKit

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}

struct MapView: View {
    var city: City
    var body: some View {
        
        let markers = [Marker(location: MapMarker(coordinate: CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon), tint: .red))]
        
        Map(coordinateRegion: .constant(city.coordinateRegion), showsUserLocation: false,
            annotationItems: markers) { marker in
            marker.location
        }.edgesIgnoringSafeArea(.all)
    }
}
