import Foundation
import UIKit

func qr(from string: String) -> UIImage? {
    guard
        let data = string.data(using: .ascii),
        let filter = CIFilter(name: "CIQRCodeGenerator")
        else { return nil }

    filter.setValue(data, forKey: "inputMessage")

    guard let output = filter.outputImage?.transformed(by: .init(scaleX: 3, y: 3))
        else { return nil }

    return UIImage(ciImage: output)
}

let image = qr(from: "https://srz.io")
image
