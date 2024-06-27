//
//  PhotoSpot+CoreDataProperties.swift
//  IOS203PhotoMap_33
//
//  Created by OLIVER LIAO on 2024/6/19.
//
//

import Foundation
import CoreData

extension PhotoSpot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoSpot> {
        return NSFetchRequest<PhotoSpot>(entityName: "PhotoSpot")
    }

    @NSManaged public var address: String?
    @NSManaged public var comment: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var imageData: Data?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: Date?

}

extension PhotoSpot : Identifiable {
    public var stringUpdatedAt: String { dateFormatter(date: updatedAt ?? Date()) }
    
    func dateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        return dateFormatter.string(from: date)
    }
}
