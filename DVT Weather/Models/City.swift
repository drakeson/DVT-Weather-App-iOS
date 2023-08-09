//
//  City.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 04/08/2023.
//

import Foundation
import MapKit

struct City: Identifiable {
    
    var id: UUID = UUID()
    var name: String
    var temp: Double
    var tempMax: Double
    var tempMin: Double
    var weatherMain: String
    var lon: Double
    var lat: Double
    var wind: Double
    var pressure: Int
    var humidity: Int
    
    init(from coreDataCity: Cities) {
        self.name = coreDataCity.name ?? ""
        self.temp = coreDataCity.temp
        self.tempMin = coreDataCity.tempMin
        self.tempMax = coreDataCity.tempMax
        self.weatherMain = coreDataCity.weatherMain  ?? ""
        self.lon = coreDataCity.lon
        self.lat = coreDataCity.lat
        self.wind = coreDataCity.wind
        self.pressure = coreDataCity.pressure
        self.humidity = coreDataCity.humidity
    }
    
    var coordinateRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
}
