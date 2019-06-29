//
//  Category+CoreDataClass.swift
//  Documents Core Data Relationships
//
//  Created by Felipe Costa on 6/28/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Category)
public class Category: NSManagedObject {
    convenience init?(name: String?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let name = name, name != "" else {
                return nil
        }
        self.init(entity: Category.entity(), insertInto: managedContext)
        self.name = name
    }
}
