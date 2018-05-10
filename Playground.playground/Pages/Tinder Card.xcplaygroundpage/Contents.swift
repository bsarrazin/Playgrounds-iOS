import Foundation
import PlaygroundSupport
import UIKit

class ViewController: UIViewController {
    
    private var cardView: UIView!
    private var animator: UIDynamicAnimator!
    private var snapBehavior: UISnapBehavior!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureGestures()
        
        snapBehavior = UISnapBehavior(item: cardView, snapTo: view.center)
        animator = UIDynamicAnimator(referenceView: view)
        animator.addBehavior(snapBehavior)
    }
    
    private func configureView() {
        view.frame = .init(
            x: 0, y: 0,
            width: 320, height: 480
        )
        view.backgroundColor = .white
    }
    
    private func configureCardView(recognizer: UIPanGestureRecognizer) {
        let rect = CGRect(
            x: 110, y: 190,
            width: 100, height: 100
        )
        let cardView = UIView(frame: rect)
        cardView.backgroundColor = .red
        cardView.addGestureRecognizer(recognizer)
        cardView.isUserInteractionEnabled = true
        view.addSubview(cardView)
        self.cardView = cardView
    }
    
    private func configureGestures() {
        let recognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(didRecognizePan(recognizer:))
        )
        configureCardView(recognizer: recognizer)
    }
    
    @objc
    func didRecognizePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animator.removeBehavior(snapBehavior)
        case .changed:
            let translation = recognizer.translation(in: view)
            cardView.center = .init(
                x: cardView.center.x + translation.x,
                y: cardView.center.y + translation.y
            )
            recognizer.setTranslation(.zero, in: view)
        case .ended, .cancelled, .failed:
            animator.addBehavior(snapBehavior)
        case .possible:
            break
        }
    }
    
}


let vc = ViewController()
PlaygroundPage.current.liveView = vc.view

