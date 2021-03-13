import SwiftUI
import MobileShieldKit

struct DailyScrum: Identifiable {
    let id: UUID
    var title: String
    var attendees: [String]
    var lengthInMinutes: Int
    var color: Color

    init(id: UUID = .init(), title: String, attendees: [String], lengthInMinutes: Int, color: Color) {
        self.id = id
        self.title = title
        self.attendees = attendees
        self.lengthInMinutes = lengthInMinutes
        self.color = color
    }
}

extension DailyScrum {
    static var data: [Self] {
        [
            .init(title: "Design", attendees: ["Cath", "Daisy", "Simon", "Jonathan"], lengthInMinutes: 10, color: .init("Design")),
            .init(title: "App Dev", attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"], lengthInMinutes: 5, color: .init("App Dev")),
            .init(title: "Web Dev", attendees: ["Chella", "Chris", "Christina", "Eden", "Karla", "Lindsey", "Aga", "Chad", "Jenn", "Sara"], lengthInMinutes: 1, color: .init("Web Dev"))
        ]
    }
}

extension DailyScrum {
    struct Data {
        var title: String = ""
        var attendees: [String] = []
        var lengthInMinutes: Double = 5.0
        var color: Color = .random
    }

    var data: Data {
        .init(title: title, attendees: attendees, lengthInMinutes: Double(lengthInMinutes), color: color)
    }
}

extension DailyScrum {
    mutating func update(from: Data) {
        title = from.title
        attendees = from.attendees
        lengthInMinutes = Int(from.lengthInMinutes)
        color = from.color
    }
}
