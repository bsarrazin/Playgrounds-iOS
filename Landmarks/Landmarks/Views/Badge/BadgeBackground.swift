import SwiftUI

struct BadgeBackground: View {
    var body: some View {
        GeometryReader { geo in
            Path { path in
                var width: CGFloat = min(geo.size.width, geo.size.height)
                let height = width
                let scaleX: CGFloat = 0.832
                let offsetX = (width * (1.0 - scaleX)) / 2.0
                width *= scaleX

                path.move(to: CGPoint(x: width * 0.95 + offsetX, y: height * 0.20))

                HexagonParameters.segments.forEach { segment in
                    path.addLine(to: .init(x: width * segment.line.x + offsetX, y: height * segment.line.y))
                    path.addQuadCurve(
                        to: .init(x: width * segment.curve.x + offsetX, y: height * segment.curve.y),
                        control: .init(x: width * segment.control.x + offsetX, y: height * segment.control.y)
                    )
                }
            }
            .fill(
                LinearGradient(
                    gradient: .init(colors: [Self.gradientStart, Self.gradientEnd]),
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 0.6))
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }

    static let gradientStart = Color(red: 239 / 255, green: 120 / 255, blue: 221 / 255)
    static let gradientEnd = Color(red: 239 / 255, green: 172 / 255, blue: 120 / 255)
}

struct BadgeBackground_Previews: PreviewProvider {
    static var previews: some View {
        BadgeBackground()
    }
}
