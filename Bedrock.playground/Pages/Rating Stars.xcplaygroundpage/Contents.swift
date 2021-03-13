import UIKit

protocol RatingViewDelegate: class {
    func ratingView(_ ratingView: RatingView, didChangeRating rating: Int)
}

class RatingView: UIView {

    // MARK: - Delegate
    weak var delegate: RatingViewDelegate?

    // MARK: - Properties
    private let isEditable: Bool = true
    private let nbValues: Int
    private let offImage: UIImage
    private let onImage: UIImage
    private(set) var rating: Int = 0 {
        didSet {
            rating = min(nbValues, rating)
            updateUI()
        }
    }
    private var imageViews: [UIImageView] = []

    // MARK: - Initialization
    init(frame: CGRect, nbValues: Int, offImage: UIImage, onImage: UIImage) {
        self.nbValues = nbValues
        self.offImage = offImage
        self.onImage = onImage
        super.init(frame: frame)

        addImageViews()
        layout()
    }
    required init?(coder: NSCoder) {
        fatalError("This initializer isn't supported.")
    }

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()

        addImageViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    // MARK: - UI
    private func addImageViews() {
        guard subviews.isEmpty else { return }

        (0..<nbValues).forEach { _ in addSubview(UIImageView(image: offImage)) }
        imageViews = subviews.compactMap { $0 as? UIImageView }
    }
    private func layout() {
        guard !imageViews.isEmpty
            else { return }

        let imageWidth = offImage.size.width / 2
        let distance = (bounds.width - (offImage.size.width * CGFloat(nbValues))) / CGFloat(nbValues + 1) + imageWidth

        imageViews.enumerated().forEach { [frame] index, view in
            view.frame = .init(x: 0, y: 0, width: offImage.size.width, height: offImage.size.height)
            view.center = .init(
                x: CGFloat(index + 1) * distance + imageWidth * CGFloat(index),
                y: frame.height / 2
            )
        }
    }
    private func updateUI() {
        guard !imageViews.isEmpty else { return }

        var split = 0
        (0..<rating).forEach {
            let view = imageViews[$0]
            view.image = onImage
            split += 1
        }

        (split..<nbValues).forEach {
            let view = imageViews[$0]
            view.image = offImage
        }
    }

    // MARK: - Touches
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEditable else { return }

        handle(touches: touches)
        delegate?.ratingView(self, didChangeRating: rating)
    }
    private func handle(touches: Set<UITouch>) {
        let touch = touches.first!
        let location = touch.location(in: self)

        for index in (0..<nbValues).reversed() where location.x >= imageViews[index].frame.minX {
            rating = index + 1
            return
        }

        rating = 0
    }
}

class Delegate: RatingViewDelegate {
    func ratingView(_ ratingView: RatingView, didChangeRating rating: Int) {
        print("rating: \(rating)")
    }
}
let delegate = Delegate()
let view = RatingView(
    frame: .init(origin: .zero, size: .init(width: 200, height: 50)),
    nbValues: 5,
    offImage: UIImage(named: "star_off")!,
    onImage: UIImage(named: "star_on")!
)
view.backgroundColor = .white
view.delegate = delegate
view.setNeedsLayout()

import PlaygroundSupport
PlaygroundPage.current.liveView = view
