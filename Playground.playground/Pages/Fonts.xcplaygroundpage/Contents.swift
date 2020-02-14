import UIKit

UIFont.familyNames.sorted().forEach {
    print("Family: \($0)")
    UIFont.fontNames(forFamilyName: $0).sorted().forEach {
        print("\tName: \($0)")
    }
}
