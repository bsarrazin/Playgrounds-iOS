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
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return button
    }
}

extension UITextField {
    static func make(placeholder: String) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.backgroundColor = #colorLiteral(red: 1, green: 0.9803921569, blue: 0.5882352941, alpha: 1)
        textField.placeholder = placeholder
        textField.textAlignment = .center
        return textField
    }
}

struct Credentials {
    let email: String
    let password: String
}

extension Optional where Wrapped == String {
    var orEmpty: String {
        switch self {
        case .some(let value): return value
        case .none: return ""
        }
    }
}

struct Remote {
    
    enum Error: Swift.Error {
        case invalidCredentials
    }
    
    func fetch(with credentials: Credentials) -> Observable<String> {
        return Observable.create { observer in
            if credentials.email == "b@srz.io", credentials.password == "password" {
                observer.onNext("SUCCESS")
                observer.onCompleted()
            } else {
                observer.onError(Error.invalidCredentials)
            }
            
            return Disposables.create()
        }
    }
    
}

class ViewController: UIViewController {
    
    private let bag = DisposeBag()
    private let remote = Remote()
    
    @IBOutlet private(set) var button: UIButton!
    @IBOutlet private(set) var emailTextField: UITextField!
    @IBOutlet private(set) var passwordTextField: UITextField!
    
    convenience init() { self.init(nibName: nil, bundle: nil) }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        configureTextFields()
        configureButton()
    }
    
    private func configureButton() {
        button = UIButton.make(title: "TAP ME!")
        view.addSubview(button)
        button.frame = makeFrame(140)
    }
    
    private func configureTextFields() {
        emailTextField = UITextField.make(placeholder: "EMAIL")
        view.addSubview(emailTextField)
        emailTextField.frame = makeFrame(60)
        
        passwordTextField = UITextField.make(placeholder: "PASSWORD")
        view.addSubview(passwordTextField)
        passwordTextField.frame = makeFrame(100)
    }
    
    private func makeFrame(_ y: CGFloat) -> CGRect {
        let size = view.bounds
        let width: CGFloat = size.width * 3/4
        let height: CGFloat = 30.0
        let x: CGFloat = (size.width - width) / 2
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let credentials = Observable<Credentials>.combineLatest(
            emailTextField.rx.text,
            passwordTextField.rx.text) {
                return .init(email: $0.orEmpty, password: $1.orEmpty)
            }
        
        button.rx.tap
            .withLatestFrom(credentials)
            .subscribe(onNext: { creds in
                print(creds)
            })
            .disposed(by: bag)
    }
}

let frame = CGRect(origin: .zero, size: UIDevice.Metrics.iPadPro97.size)
let window = UIWindow(frame: frame)
let viewController = ViewController()
window.rootViewController = viewController
window.makeKeyAndVisible()

PlaygroundPage.current.liveView = window
PlaygroundPage.current.needsIndefiniteExecution = true
