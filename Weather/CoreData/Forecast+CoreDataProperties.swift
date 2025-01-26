//
//  Forecast+CoreDataProperties.swift
//  Weather
//
//  Created by Ruslan Kandratsenka on 24.01.25.
//
//

import Foundation
import CoreData


extension Forecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
        return NSFetchRequest<Forecast>(entityName: "Forecast")
    }

    @NSManaged public var country: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var name: String?
    @NSManaged public var temperature: Double
    @NSManaged public var windSpeed: Double
    @NSManaged public var windAngle: Int16
    @NSManaged public var timestamp: Int32

}

extension Forecast : Identifiable {

}
