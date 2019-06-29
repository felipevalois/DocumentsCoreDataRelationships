//
//  Category+CoreDataProperties.swift
//  Documents Core Data Relationships
//
//  Created by Felipe Costa on 6/28/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var rawDocument: NSOrderedSet?

}

// MARK: Generated accessors for rawDocument
extension Category {

    @objc(insertObject:inRawDocumentAtIndex:)
    @NSManaged public func insertIntoRawDocument(_ value: Document, at idx: Int)

    @objc(removeObjectFromRawDocumentAtIndex:)
    @NSManaged public func removeFromRawDocument(at idx: Int)

    @objc(insertRawDocument:atIndexes:)
    @NSManaged public func insertIntoRawDocument(_ values: [Document], at indexes: NSIndexSet)

    @objc(removeRawDocumentAtIndexes:)
    @NSManaged public func removeFromRawDocument(at indexes: NSIndexSet)

    @objc(replaceObjectInRawDocumentAtIndex:withObject:)
    @NSManaged public func replaceRawDocument(at idx: Int, with value: Document)

    @objc(replaceRawDocumentAtIndexes:withRawDocument:)
    @NSManaged public func replaceRawDocument(at indexes: NSIndexSet, with values: [Document])

    @objc(addRawDocumentObject:)
    @NSManaged public func addToRawDocument(_ value: Document)

    @objc(removeRawDocumentObject:)
    @NSManaged public func removeFromRawDocument(_ value: Document)

    @objc(addRawDocument:)
    @NSManaged public func addToRawDocument(_ values: NSOrderedSet)

    @objc(removeRawDocument:)
    @NSManaged public func removeFromRawDocument(_ values: NSOrderedSet)

}
