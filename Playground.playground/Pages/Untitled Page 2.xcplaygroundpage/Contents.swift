//: [Previous](@previous)

import PlaygroundSupport
import RxCocoa
import RxSwift
import UIKit

UIDevice.Metrics.iPhone8Plus.size

//let str = NSAttributedString(string: "")
//let desiredWidth: CGFloat = 300
//let boundingRect = CGSize(width: 300, height: CGFloat.greatestFiniteMagnitude)
//let rect = str.boundingRect(with: boundingRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)



class ViewController: UIViewController {
    private let bag = DisposeBag()
    private var button: UIButton!
    
    convenience init() { self.init(nibName: nil, bundle: nil) }
    
    override func loadView() {
        super.loadView()
        view.bounds = CGRect(origin: .zero, size: UIDevice.Metrics.iPhoneX.size)
        view.backgroundColor = .white
        
        button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("FOO", for: .normal)
        button.rx.tap
            .subscribe(onNext: { print("tap") })
            .disposed(by: bag)
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 250),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

let viewController = ViewController()
PlaygroundPage.current.liveView = viewController.view
PlaygroundPage.current.needsIndefiniteExecution = true
