import Foundation

/*
 MIT License

 Copyright (c) 2017 Ruslan Serebriakov <rsrbk1@gmail.com>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

@objc public protocol SRCountdownTimerDelegate: class {
    @objc optional func timerDidUpdateCounterValue(sender: SRCountdownTimer, newValue: Int)
    @objc optional func timerDidStart(sender: SRCountdownTimer)
    @objc optional func timerDidPause(sender: SRCountdownTimer)
    @objc optional func timerDidResume(sender: SRCountdownTimer)
    @objc optional func timerDidEnd(sender: SRCountdownTimer, elapsedTime: TimeInterval)
}

public class SRCountdownTimer: UIView {
    @IBInspectable public var lineWidth: CGFloat = 2.0
    @IBInspectable public var lineColor: UIColor = .black
    @IBInspectable public var trailLineColor: UIColor = UIColor.lightGray.withAlphaComponent(0.5)

    @IBInspectable public var isLabelHidden: Bool = false
    @IBInspectable public var labelFont: UIFont?
    @IBInspectable public var labelTextColor: UIColor?
    @IBInspectable public var staticLabelText: String?
    @IBInspectable public var timerFinishingText: String?

    public weak var delegate: SRCountdownTimerDelegate?

    // use minutes and seconds for presentation
    public var useMinutesAndSecondsRepresentation = false
    public var moveClockWise = true

    private var timer: Timer?
    private var beginingValue: Int = 1
    private var totalTime: TimeInterval = 1
    private var elapsedTime: TimeInterval = 0
    private var interval: TimeInterval = 1 // Interval which is set by a user
    private let fireInterval: TimeInterval = 0.01 // ~60 FPS

    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        self.addSubview(label)

        label.textAlignment = .center
        label.frame = self.bounds
        if let font = self.labelFont {
            label.font = font
        }
        if let color = self.labelTextColor {
            label.textColor = color
        }

        return label
    }()
    private var currentCounterValue: Int = 0 {
        didSet {
            if !isLabelHidden {
                if let text = timerFinishingText, currentCounterValue == 0 {
                    counterLabel.text = text
                } else {
                    if let text = staticLabelText {
                        counterLabel.text = text
                    } else
                    if useMinutesAndSecondsRepresentation {
                        counterLabel.text = getMinutesAndSeconds(remainingSeconds: currentCounterValue)
                    } else {
                        counterLabel.text = "\(currentCounterValue)"
                    }
                }
            }

            delegate?.timerDidUpdateCounterValue?(sender: self, newValue: currentCounterValue)
        }
    }

    // MARK: Inits
    override public init(frame: CGRect) {
        if frame.width != frame.height {
            fatalError("Please use a rectangle frame for SRCountdownTimer")
        }

        super.init(frame: frame)

        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func draw(_ rect: CGRect) {
        super.draw(rect)

        let context = UIGraphicsGetCurrentContext()
        let radius = (rect.width - lineWidth) / 2

        var currentAngle : CGFloat!

        if moveClockWise {
            currentAngle = CGFloat((.pi * 2 * elapsedTime) / totalTime)
        } else {
            currentAngle = CGFloat(-(.pi * 2 * elapsedTime) / totalTime)
        }

        context?.setLineWidth(lineWidth)

        // Main line
        context?.beginPath()
        context?.addArc(
            center: CGPoint(x: rect.midX, y:rect.midY),
            radius: radius,
            startAngle: currentAngle - .pi / 2,
            endAngle: .pi * 2 - .pi / 2,
            clockwise: false)
        context?.setStrokeColor(lineColor.cgColor)
        context?.strokePath()

        // Trail line
        context?.beginPath()
        context?.addArc(
            center: CGPoint(x: rect.midX, y:rect.midY),
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: currentAngle - .pi / 2,
            clockwise: false)
        context?.setStrokeColor(trailLineColor.cgColor)
        context?.strokePath()
    }

    // MARK: Public methods
    /**
     * Starts the timer and the animation. If timer was previously runned, it'll invalidate it.
     * - Parameters:
     *   - beginingValue: Value to start countdown from.
     *   - interval: Interval between reducing the counter(1 second by default)
     */
    public func start(beginingValue: Int, interval: TimeInterval = 1) {
        self.beginingValue = beginingValue
        self.interval = interval

        totalTime = TimeInterval(beginingValue) * interval
        elapsedTime = 0
        currentCounterValue = beginingValue

        timer?.invalidate()
        timer = Timer(timeInterval: fireInterval, target: self, selector: #selector(SRCountdownTimer.timerFired(_:)), userInfo: nil, repeats: true)

        RunLoop.main.add(timer!, forMode: .common)

        delegate?.timerDidStart?(sender: self)
    }

    /**
     * Pauses the timer with saving the current state
     */
    public func pause() {
        timer?.fireDate = Date.distantFuture

        delegate?.timerDidPause?(sender: self)
    }

    /**
     * Resumes the timer from the current state
     */
    public func resume() {
        timer?.fireDate = Date()

        delegate?.timerDidResume?(sender: self)
    }

    /**
     * Reset the timer
     */
    public func reset() {
        self.currentCounterValue = 0
        timer?.invalidate()
        self.elapsedTime = 0
        setNeedsDisplay()
    }

    /**
     * End the timer
     */
    public func end() {
        self.currentCounterValue = 0
        timer?.invalidate()

        delegate?.timerDidEnd?(sender: self, elapsedTime: elapsedTime)
    }

    /**
     * Calculate value in minutes and seconds and return it as String
     */
    private func getMinutesAndSeconds(remainingSeconds: Int) -> (String) {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds - minutes * 60
        let secondString = seconds < 10 ? "0" + seconds.description : seconds.description
        return minutes.description + ":" + secondString
    }

    // MARK: Private methods
    @objc private func timerFired(_ timer: Timer) {
        elapsedTime += fireInterval

        if elapsedTime <= totalTime {
            setNeedsDisplay()

            let computedCounterValue = beginingValue - Int(elapsedTime / interval)
            if computedCounterValue != currentCounterValue {
                currentCounterValue = computedCounterValue
            }
        } else {
            end()
        }
    }
}

class CountdownView: UIView {

    // MARK: - Initialization
    override public init(frame: CGRect) {
        guard frame.isSquare
            else { fatalError("This UI components only gets displayed correct if the frame is a square.") }

        super.init(frame: frame)

        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Timing
    private var count: Int = 0
    private var elapsedTimeInterval: TimeInterval = 0
    private var refreshTimeInterval: TimeInterval = 1
    private var startValue: Int = 1
    private var timer: Timer?
    private var totalTimeInterval: TimeInterval = 1

    func start(at value: Int, refreshTimeInterval: TimeInterval, labelText: String = "") {
        self.startValue = value
        self.refreshTimeInterval = refreshTimeInterval
        self.totalTimeInterval = TimeInterval(value) * refreshTimeInterval
        self.elapsedTimeInterval = 0
        self.count = value

        self.label.text = labelText

        self.timer?.invalidate()
        self.timer = Timer(timeInterval: .sixtyFPS, repeats: true) { [weak self] timer in
            guard let self = self else { return timer.invalidate() }

            self.elapsedTimeInterval += .sixtyFPS

            guard self.elapsedTimeInterval <= self.totalTimeInterval
                else { return self.stop() }

            self.setNeedsDisplay()
            let count = self.startValue - Int(self.elapsedTimeInterval / self.refreshTimeInterval)
            if count != self.count {
                self.count = count
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    func stop() {
        count = 0
        timer?.invalidate()
    }
    func pause() {
        timer?.fireDate = .distantFuture
    }
    func resume() {
        timer?.fireDate = .init()
    }
    func reset() {
        stop()
        elapsedTimeInterval = 0
        setNeedsDisplay()
    }

    // MARK: - Configurable UI
    var lineWidth: CGFloat = 2.0
    var lineColour: UIColor = .gray
    var trackColour: UIColor = .clear
    var textColour: UIColor = .black
    var font: UIFont = .systemFont(ofSize: 17)

    // MARK: - UI
    private lazy var label: UILabel = {
        let label = UILabel()
        self.addSubview(label)

        label.font = font
        label.frame = bounds
        label.textAlignment = .center
        label.textColor = textColour
        return label
    }()
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let angle = CGFloat((elapsedTimeInterval * 2 * .pi) / totalTimeInterval)
        let radius = (rect.width - lineWidth) / 2

        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(lineWidth)

        // Track
        ctx?.beginPath()
        ctx?.addArc(
            center: .init(x: rect.midX, y: rect.midY),
            radius: radius,
            startAngle: angle - .pi / 2,
            endAngle: .pi * 2 - .pi / 2,
            clockwise: false
        )
        ctx?.setStrokeColor(trackColour.cgColor)
        ctx?.strokePath()

        // Progress Line
        ctx?.beginPath()
        ctx?.addArc(
            center: .init(x: rect.midX, y: rect.midY),
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: angle - .pi / 2,
            clockwise: false
        )
        ctx?.setStrokeColor(lineColour.cgColor)
        ctx?.strokePath()
    }
}

private extension CGRect {
    var isSquare: Bool { height == width }
}

private extension TimeInterval {
    static let sixtyFPS: TimeInterval = 0.01
}

func makeSR() -> SRCountdownTimer {
    let countdown = SRCountdownTimer(frame: .init(x: 0, y: 0, width: 100, height: 100))
    countdown.lineWidth = 2.0
    countdown.lineColor = .black
    countdown.trailLineColor = .white // UIColor.lightGray.withAlphaComponent(0.5)
    countdown.isLabelHidden = false
    countdown.labelFont = .boldSystemFont(ofSize: 75)
    countdown.labelTextColor = .red
    //countdown.staticLabelText = "\u{2B24}"
    countdown.staticLabelText = "\u{25CF}"
    //countdown.timerFinishingText = "END"
    countdown.backgroundColor = .white
    countdown.start(beginingValue: 5, interval: 1)
    countdown.useMinutesAndSecondsRepresentation = false
    return countdown
}

func makeMine() -> CountdownView {
    let view = CountdownView(frame: .init(x: 0, y: 250, width: 100, height: 100))
    view.backgroundColor = .white
    view.lineColour = .red
    view.lineWidth = 2
    view.textColour = .red
    view.trackColour = .clear
    view.font = .systemFont(ofSize: 30)
    view.start(at: 5, refreshTimeInterval: 1, labelText: "\u{25CF}")
    return view
}

let view = UIView(frame: .init(x: 0, y: 0, width: 400, height: 600))
view.backgroundColor = .white
view.addSubview(makeSR())
view.addSubview(makeMine())

import PlaygroundSupport
PlaygroundPage.current.liveView = view


