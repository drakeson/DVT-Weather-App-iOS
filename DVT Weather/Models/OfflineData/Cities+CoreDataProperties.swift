//
//  Cities+CoreDataProperties.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 07/08/2023.
//
//

import Foundation
import CoreData


extension Cities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cities> {
        return NSFetchRequest<Cities>(entityName: "Cities")
    }

    @NSManaged public var tempMin: Double
    @NSManaged public var tempMax: Double
    @NSManaged public var weatherMain: String?
    @NSManaged public var name: String?
    @NSManaged public var lon: Double
    @NSManaged public var lat: Double
    @NSManaged public var temp: Double
    @NSManaged public var createdAt: Date
    @NSManaged public var wind: Double
    @NSManaged public var humidity: Int
    @NSManaged public var pressure: Int

}

extension Cities : Identifiable {

}
