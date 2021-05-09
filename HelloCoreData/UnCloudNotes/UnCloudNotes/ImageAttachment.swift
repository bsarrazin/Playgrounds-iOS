import CoreData
import Foundation
import UIKit

class ImageAttachment: Attachment {
    @NSManaged var image: UIImage?
    @NSManaged var width: Float
    @NSManaged var height: Float
    @NSManaged var caption: String
}


