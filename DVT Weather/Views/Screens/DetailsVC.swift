//
//  DetailsVC.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 07/08/2023.
//

import SwiftUI
import CoreData


struct DetailsVC: View {
    var city: City
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(city.name)
                .font(.title)
                .fontWeight(.medium)
            Text("Weather Type: \(city.weatherMain)")
            Text("Temperature: \(city.temp)°C")
            Text("Pressure:  \(city.pressure)hPa")
            Text("Humidity: \(city.humidity)%")
            Text("Wind Speed: \(city.wind)km/h")
            
            MapView(city: city).frame(height: 400)
        }
        .padding()
        .navigationBarTitle("\(city.name) City")
    }
}


struct DetailsVC_Previews: PreviewProvider {
    static var previews: some View {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Cities> = Cities.fetchRequest()
        
        do {
            let fetchedCities = try managedObjectContext.fetch(fetchRequest)
            if let firstCity = fetchedCities.first {
                let city = City(from: firstCity)
                return AnyView(Group {
                    DetailsVC(city: city)
                })
            } else {
                return AnyView(Text("No Cities found in Core Data"))
            }
        } catch {
            return AnyView(Text("Error fetching cities: \(error.localizedDescription)"))
        }
    }
}
