//
//  Document+CoreDataProperties.swift
//  Documents Core Data Relationships
//
//  Created by Felipe Costa on 6/28/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var body: String?
    @NSManaged public var modifiedDate: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var size: Int64
    @NSManaged public var category: Category?

}
