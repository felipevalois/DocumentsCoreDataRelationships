//
//  Document+CoreDataClass.swift
//  Documents Core Data Relationships
//
//  Created by Felipe Costa on 6/28/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//
//

import Foundation
import UIKit
import CoreData

@objc(Document)
public class Document: NSManagedObject {
    var date: Date? {
        get {
            return modifiedDate as Date?
        }
        set {
            modifiedDate = newValue as NSDate?
        }
    }
    
    convenience init?(name: String?, body: String?, category: Category) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let name = name, name != "" else {
                return nil
        }
        self.init(entity: Document.entity(), insertInto: managedContext)
        self.name = name
        self.body = body
        if let size = body?.count {
            self.size = Int64(size)
        } else {
            self.size = 0
        }
        
        self.date = Date(timeIntervalSinceNow: 0)
        self.category = category
    }
    
    func update(name: String, body: String?, category: Category) {
        self.name = name
        self.body = body
        if let size = body?.count {
            self.size = Int64(size)
        } else {
            self.size = 0
        }
        
        self.date = Date(timeIntervalSinceNow: 0)
        self.category = category
    }
}
