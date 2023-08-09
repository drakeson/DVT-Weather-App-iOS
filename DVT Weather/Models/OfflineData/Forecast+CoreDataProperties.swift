//
//  Forecast+CoreDataProperties.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 07/08/2023.
//
//

import Foundation
import CoreData


extension Forecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
        return NSFetchRequest<Forecast>(entityName: "Forecast")
    }

    @NSManaged public var id: UUID
    @NSManaged public var dt: Int64
    @NSManaged public var tempMin: Double
    @NSManaged public var tempMax: Double
    @NSManaged public var weatherMain: String?

}

extension Forecast : Identifiable {

}
