import PlaygroundSupport
import RxSwift
import RxCocoa

/// Provides input/output namespacing
class ViewModel<Input, Output> {
    let input: Input
    let output: Output
    
    init(input: Input, output: Output) {
        self.input = input
        self.output = output
    }
}

/// FooViewModel.swift
protocol FooInput {
    var doSomething: AnyObserver<Void> { get }
}

protocol FooOutput {
    var getSomething: Driver<[String]> { get }
}

class FooViewModel: FooInput, FooOutput {
    let doSomething: AnyObserver<Void>
    let getSomething: Driver<[String]>
    
    init(api: API) {
        let driver = Driver<Void>.create()
        
        self.doSomething = driver.input
        self.getSomething = driver.output.flatMap {
            return api
                .obtainIds()
                .asDriver(onErrorJustReturn: [])
                .map { $0.flatMap(String.init) }
        }
    }
}

/// FooViewController.swift
class VC {
    private let disposeBag = DisposeBag()
    
    private(set) lazy var viewModel: ViewModel<FooInput, FooOutput> = {
        let viewModel = FooViewModel(api: API())
        return ViewModel(input: viewModel, output: viewModel)
    }()
    
    func viewDidLoad() {
        viewModel.output
            .getSomething.drive(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    func buttonTap() {
        viewModel.input.doSomething.onNext(())
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true

let vc = VC()
vc.viewDidLoad()
vc.buttonTap()
    
    
