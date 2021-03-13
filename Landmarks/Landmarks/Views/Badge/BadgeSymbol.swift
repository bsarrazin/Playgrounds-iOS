import SwiftUI

struct BadgeSymbol: View {

    static let symbolColor = Color(red: 79 / 255, green: 79 / 255, blue: 191 / 255)

    var body: some View {
        GeometryReader { geo in
            Path { path in
                let width = min(geo.size.width, geo.size.height)
                let height = width * 0.75
                let spacing = width * 0.030
                let middle = width * 0.5
                let topWidth = width * 0.226
                let topHeight = height * 0.488

                path.addLines([
                    .init(x: middle, y: spacing),
                    .init(x: middle - topWidth, y: topHeight - spacing),
                    .init(x: middle, y: topHeight / 2 + spacing),
                    .init(x: middle + topWidth, y: topHeight - spacing),
                    .init(x: middle, y: spacing),
                ])

                path.move(to: .init(x: middle, y: topHeight / 2 + spacing * 3))

                path.addLines([
                    .init(x: middle - topWidth, y: topHeight + spacing),
                    .init(x: spacing, y: height - spacing),
                    .init(x: width - spacing, y: height - spacing),
                    .init(x: middle + topWidth, y: topHeight + spacing),
                    .init(x: middle, y: topHeight / 2 + spacing * 3),
                ])
            }
            .fill(Self.symbolColor)
        }
    }
}

struct RotatedBadgeSymbol: View {

    let angle: Angle

    var body: some View {
        BadgeSymbol()
            .padding(-60)
            .rotationEffect(angle, anchor: .bottom)
    }
}

struct BadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BadgeSymbol()
            RotatedBadgeSymbol(angle: Angle(degrees: 5))
        }
    }
}
