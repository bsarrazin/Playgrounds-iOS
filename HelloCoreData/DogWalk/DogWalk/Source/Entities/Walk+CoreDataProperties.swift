//
//  Walk+CoreDataProperties.swift
//  DogWalk
//
//  Created by Ben Sarrazin on 2021-05-05.
//  Copyright © 2021 Razeware. All rights reserved.
//
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }

    @NSManaged public var date: Date?
    @NSManaged public var dog: Dog?

}

extension Walk : Identifiable {

}
