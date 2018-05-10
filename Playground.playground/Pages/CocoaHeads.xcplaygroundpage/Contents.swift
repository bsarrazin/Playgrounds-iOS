import PlaygroundSupport
import RxCocoa
import RxSwift
import UIKit

extension UIButton {
    static func make(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.2745098039, blue: 0.3725490196, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

class ViewController: UIViewController {
    
    private let bag = DisposeBag()
    
    @IBOutlet private(set) var button: UIButton!
    
    convenience init() { self.init(nibName: nil, bundle: nil) }
    
    override func loadView() {
        super.loadView()
        configureView()
        configureButton()
    }
    
    private func configureView() {
        view.bounds = CGRect(origin: .zero, size: UIDevice.Metrics.iPhoneX.size)
        view.backgroundColor = .white
    }
    
    private func configureButton() {
        button = UIButton.make(title: "Tap Me!")
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 250),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.rx.tap
            .subscribe(onNext: {
                print("foo")
            })
            .disposed(by: bag)
    }
}

let viewController = ViewController()
PlaygroundPage.current.liveView = viewController.view
PlaygroundPage.current.needsIndefiniteExecution = true
