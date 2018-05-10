import Alamofire
import PlaygroundSupport
import RxSwift
import UIKit

PlaygroundPage.current.needsIndefiniteExecution = true

/*:
 # Basics
 */

xexample("Simple Observable") { _ in
    let subscription = Observable<Int>.from([1, 2, 3])
        .subscribe { event in
            switch event {
            case .error(let error):
                print("Error: \(error)")
            case .next(let value):
                print("Next: \(value)")
            case .completed:
                print("Completed!")
            }
    }
    subscription.dispose()
}

xexample("Disposing & Terminating") { _ in
    // “Remember that an observable doesn’t do anything until it receives a subscription.”
    let bag = DisposeBag()
    Observable<Int>.from([1, 2, 3, 4, 5])
        .subscribe { event in
            switch event {
            case .error(let error):
                print("Error: \(error)")
            case .next(let value):
                print("Next: \(value)")
            case .completed:
                print("Completed!")
            }
        }
        .disposed(by: bag)
}

xexample("Using 'create'") { _ in
    let bag = DisposeBag()
    Observable<Int>
        .create { observer in
            [1, 2, 3, 4, 5].forEach { observer.onNext($0) }
            observer.onCompleted()
            return Disposables.create()
        }
        .subscribe { event in
            switch event {
            case .error(let error):
                print("Error: \(error)")
            case .next(let value):
                print("Next: \(value)")
            case .completed:
                print("Completed!")
            }
        }
        .disposed(by: bag)
}

/*:
 # Lifecycle
 */

xexample("Lifecycle") { _ in
    example("Completed") { _ in
        let bag = DisposeBag()
        Observable<Int>
            .create { observer in
                observer.onNext(1)
                observer.onNext(2)
                observer.onCompleted()
                observer.onNext(3) // Will never be emmitted
                return Disposables.create()
            }
            .subscribe(
                onNext: { (i) in
                    print("Next: \(i)")
            },
                onError: { error in
                    print("Error: \(error)")
            },
                onCompleted: {
                    print("Completed!")
            },
                onDisposed: {
                    print("Disposed!")
            })
            .disposed(by: bag)
    }
    
    example("Error") { _ in
        let bag = DisposeBag()
        enum ObservableError: Error { case example }
        Observable<Int>
            .create { observer in
                observer.onNext(1)
                observer.onNext(2)
                observer.onError(ObservableError.example)
                observer.onNext(3) // Will never be emmitted
                return Disposables.create()
            }
            .subscribe(
                onNext: { (i) in
                    print("Next: \(i)")
            },
                onError: { error in
                    print("Error: \(error)")
            },
                onCompleted: {
                    print("Completed!")
            },
                onDisposed: {
                    print("Disposed!")
            })
            .disposed(by: bag)
    }
}

/*:
 # Deferred Factories
 */

xexample("Deferred Factories") { _ in
    let bag = DisposeBag()
    var flip = false
    let factory: Observable<Int> = Observable.deferred {
        flip = !flip
        switch flip {
        case false:
            return Observable.of(1, 3, 5)
        case true:
            return Observable.of(2, 4, 6)
        }
    }
    
    (0...3).forEach { _ in
        factory
            .subscribe(
                onNext: { (i) in
                    print("Next: \(i)")
                },
                onError: { error in
                    print("Error: \(error)")
                },
                onCompleted: {
                    print("Completed!")
                },
                onDisposed: {
                    print("Disposed!")
                })
            .disposed(by: bag)
    }
}

/*:
 # Traits
 
 > “Traits are observables with a narrower set of behaviors than regular observables. Their use is optional; you can use a regular observable anywhere you might use a trait instead. Their purpose is to provide a way to more clearly convey your intent to readers of your code or consumers of your API. The context implied by using a trait can help make your code more intuitive.”
 */

xexample("Single") { _ in
    let bag = DisposeBag()
    enum FileReadError: Error { case fileNotFound, notReadable, unexpectedEncoding }
    Single<String>
        .create { single in
            single(.success("Hello, World!"))
            single(.error(FileReadError.fileNotFound)) // Will never be emmitted
            return Disposables.create()
        }
        .subscribe(
            onSuccess: { string in
                print("Success: \(string)")
        },
            onError: { error in
                print("Error: \(error)")
        })
        .disposed(by: bag)
}

xexample("Completable") { _ in
    let bag = DisposeBag()
    enum FileReadError: Error { case fileNotFound, notReadable, unexpectedEncoding }
    Completable
        .create { completable in
            completable(.completed)
            completable(.error(FileReadError.fileNotFound)) // Will never be emmitted
            return Disposables.create()
        }
        .subscribe(
            onCompleted: {
                print("Completed!")
        },
            onError: { error in
                print("Error: \(error)")
        })
        .disposed(by: bag)
}

xexample("Maybe") { _ in
    let bag = DisposeBag()
    enum FileReadError: Error { case fileNotFound, notReadable, unexpectedEncoding }
    Maybe<Int>.create { maybe in
        maybe(.success(1))
        maybe(.completed) // Will never be emmitted
        maybe(.error(FileReadError.fileNotFound)) // Will never be emmitted
        return Disposables.create()
        }
        .subscribe(
            onSuccess: { i in
                print("Success: \(i)")
        },
            onError: { error in
                print("Error: \(error)")
        },
            onCompleted: {
                print("Completed!")
        })
        .disposed(by: bag)
}

/*:
 # Subjects
 */

xexample("PublishSubject") { _ in
    let bag = DisposeBag()
    let subject = PublishSubject<Int>()
    subject.onNext(1) // Emitted but no observer
    subject.onNext(2) // Emitted but no observer
    subject.onNext(3) // Emitted but no observer
    subject.onNext(4) // Emitted but no observer
    subject.subscribe(onNext: { i in
            print("Next: \(i)")
        })
        .disposed(by: bag)
    subject.onNext(5)
    subject.onNext(6)
    subject.onNext(7)
    subject.onNext(8)
}
