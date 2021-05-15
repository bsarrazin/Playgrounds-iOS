import Foundation
import CoreData

extension JournalEntry {
    func stringForDate() -> String {
        guard let date = date else { return "" }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: date)
    }

    func csv() -> String {
        let coalescedHeight = height ?? ""
        let coalescedPeriod = period ?? ""
        let coalescedWind = wind ?? ""
        let coalescedLocation = location ?? ""
        let coalescedRating: String
        if let rating = rating?.int16Value {
            coalescedRating = String(rating)
        } else {
            coalescedRating = ""
        }

        return [
            stringForDate(),
            coalescedHeight,
            coalescedPeriod,
            coalescedWind,
            coalescedLocation,
            coalescedRating,
            "\n"
        ].joined(separator: ",")
    }
}
