import RxSwift
import RxCocoa

public extension Driver {
    public static func create(withDefault default: Element? = nil, startingWith value: E) -> (output: Driver<Element>, input: AnyObserver<Element>) {
        let (output, input) = create(withDefault: `default`)
        return (output.startWith(value), input)
    }
    public static func create(withDefault default: Element? = nil) -> (output: Driver<Element>, input: AnyObserver<Element>) {
        let instance = PublishSubject<Element>()
        return (
            instance.asDriver(onErrorDriveWith: `default`.map(Driver.just) ?? .never()),
            AnyObserver(instance)
        )
    }
}
