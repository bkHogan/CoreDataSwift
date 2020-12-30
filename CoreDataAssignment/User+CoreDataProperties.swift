//
//  User+CoreDataProperties.swift
//  CoreDataAssignment
//
//  Created by Field Employee on 12/29/20.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var region: String?

}

extension User : Identifiable {

}
