import Foundation
import PlaygroundSupport
import RxCocoa
import RxSwift
import UIKit

class View: UIView {
    
    // MARK: - Outlets
    private(set) var darkThemeButton: UIButton!
    private(set) var lightThemeButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        darkThemeButton = UIButton(type: .system)
        //        darkThemeButton.backgroundColor = darkThemeButton.tintColor
        darkThemeButton.layer.cornerRadius = 10
        darkThemeButton.setTitle("Dark Theme", for: .normal)
        //        darkThemeButton.setTitleColor(.white, for: .normal)
        darkThemeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(darkThemeButton)
        
        lightThemeButton = UIButton(type: .system)
        //        lightThemeButton.backgroundColor = lightThemeButton.tintColor
        lightThemeButton.layer.cornerRadius = 10
        lightThemeButton.setTitle("Light Theme", for: .normal)
        //        lightThemeButton.setTitleColor(.white, for: .normal)
        lightThemeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lightThemeButton)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        let buttonHeight: CGFloat = 50
        let margin: CGFloat = 20
        NSLayoutConstraint.activate([
            darkThemeButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            darkThemeButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: margin),
            
            lightThemeButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            lightThemeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -margin),
            
            darkThemeButton.widthAnchor.constraint(equalTo: lightThemeButton.widthAnchor),
            darkThemeButton.trailingAnchor.constraint(equalTo: lightThemeButton.leadingAnchor, constant: -margin),
            
            darkThemeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -margin),
            lightThemeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -margin),
            ])
    }
}

class ViewController: UIViewController {
    
    // MARK: - Properties
    let bag = DisposeBag()
    var customView: View { return view as! View }
    
    override func loadView() {
        view = View(frame: UIDevice.Metrics.iPhoneX.rect)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.darkThemeButton.rx.tap
            .subscribe(onNext: { _ in
                Theme.dark.apply()
                reload()
                print("dark theme")
            })
            .disposed(by: bag)
        
        customView.lightThemeButton.rx.tap
            .subscribe(onNext: { _ in
                Theme.light.apply()
                reload()
                print("light theme")
            })
            .disposed(by: bag)
    }
}

struct Theme {
    var backgroundColor: UIColor
    var tintColor: UIColor
}

extension Theme {
    static var dark: Theme {
        return .init(
            backgroundColor: .black,
            tintColor: .white
        )
    }
    static var light: Theme {
...
