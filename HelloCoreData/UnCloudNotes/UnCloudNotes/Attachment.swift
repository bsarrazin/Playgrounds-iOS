//
//  Attachment.swift
//  UnCloudNotes
//
//  Created by Ben Sarrazin on 2021-05-08.
//  Copyright © 2021 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Attachment: NSManagedObject {
    @NSManaged var created: Date?
    @NSManaged var note: Note?
}
