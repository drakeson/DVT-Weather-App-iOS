//
//  CurrentWeather+CoreDataProperties.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 07/08/2023.
//
//

import Foundation
import CoreData


extension CurrentWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeather> {
        return NSFetchRequest<CurrentWeather>(entityName: "CurrentWeather")
    }

    @NSManaged public var tempMin: Double
    @NSManaged public var tempMax: Double
    @NSManaged public var temp: Double
    @NSManaged public var name: String?
    @NSManaged public var lon: Double
    @NSManaged public var lat: Double
    @NSManaged public var weatherMain: String?
    @NSManaged public var wind: Double
    @NSManaged public var humidity: Int
    @NSManaged public var pressure: Int

}

extension CurrentWeather : Identifiable {

}
